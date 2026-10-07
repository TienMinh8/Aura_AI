import Foundation
import SwiftData
import SwiftUI

@MainActor
final class AIService {
    static let shared = AIService()
    
    // MARK: - AI Provider Configuration
    enum AIProvider: String, CaseIterable, Identifiable {
        case gemini = "Google Gemini (1.5 Flash / 2.0)"
        case openAI = "OpenAI (GPT-4o / GPT-4o-mini)"
        case custom = "Custom OpenAI-compatible (Groq / Ollama)"
        case local = "Offline Engine (Nova Local)"
        
        var id: String { rawValue }
    }
    
    @AppStorage("aura_ai_provider") var selectedProviderRaw: String = AIProvider.gemini.rawValue
    @AppStorage("aura_ai_key") var apiKey: String = ""
    @AppStorage("aura_ai_model") var modelName: String = "gemini-1.5-flash"
    @AppStorage("aura_ai_endpoint") var customEndpoint: String = "https://api.openai.com/v1/chat/completions"
    
    var selectedProvider: AIProvider {
        get { AIProvider(rawValue: selectedProviderRaw) ?? .gemini }
        set { selectedProviderRaw = newValue.rawValue }
    }
    
    private init() {}
    
    struct AIResponse {
        let content: String
        let hasAction: Bool
        let actionTitle: String?
        let actionType: String?
    }
    
    // MARK: - Async Process Query with Streaming / Cloud LLM Support
    func processQueryAsync(
        _ query: String,
        in context: ModelContext,
        events: [AuraEvent],
        habits: [Habit],
        memories: [UserMemory],
        onChunk: ((String) -> Void)? = nil
    ) async -> AIResponse {
        let trimmedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // If Gemini or Cloud provider is chosen but no API key is set yet
        if selectedProvider != .local && trimmedKey.isEmpty {
            let localFallback = processLocalQuery(query, in: context, events: events, habits: habits, memories: memories)
            let hint = selectedProvider == .gemini 
                ? "\n\n💡 *Gợi ý: Nova đang sẵn sàng kết nối Google Gemini. Chạm vào nút \"Nova\" trên đầu màn hình để dán Gemini API Key (miễn phí tại Google AI Studio) nhé.*"
                : "\n\n💡 *Gợi ý: Hãy nhập API Key trong phần Nova (Token Usage) để sử dụng \(selectedProvider.rawValue).*"
            return AIResponse(
                content: localFallback.content + hint,
                hasAction: localFallback.hasAction,
                actionTitle: localFallback.actionTitle,
                actionType: localFallback.actionType
            )
        }
        
        // If an API key is provided and a cloud provider is active, attempt Cloud LLM
        if !trimmedKey.isEmpty && selectedProvider != .local {
            do {
                let cloudResult = try await callCloudLLM(
                    query: query,
                    in: context,
                    events: events,
                    habits: habits,
                    memories: memories,
                    onChunk: onChunk
                )
                return cloudResult
            } catch {
                print("Cloud LLM call failed (\(error.localizedDescription)), falling back to Local Engine.")
                let localFallback = processLocalQuery(query, in: context, events: events, habits: habits, memories: memories)
                let note = "\n\n⚠️ *Không thể kết nối \(selectedProvider.rawValue) (\(error.localizedDescription)). Đã chuyển sang bộ xử lý nội bộ an toàn.*"
                return AIResponse(
                    content: localFallback.content + note,
                    hasAction: localFallback.hasAction,
                    actionTitle: localFallback.actionTitle,
                    actionType: localFallback.actionType
                )
            }
        }
        
        // Default / Offline Fallback
        return processLocalQuery(query, in: context, events: events, habits: habits, memories: memories)
    }
    
    /// Synchronous wrapper for instant local queries
    func processQuery(
        _ query: String,
        in context: ModelContext,
        events: [AuraEvent],
        habits: [Habit],
        memories: [UserMemory]
    ) -> AIResponse {
        return processLocalQuery(query, in: context, events: events, habits: habits, memories: memories)
    }
    
    // MARK: - Cloud LLM Caller (Google Gemini / OpenAI / Custom Compatible)
    private func callCloudLLM(
        query: String,
        in context: ModelContext,
        events: [AuraEvent],
        habits: [Habit],
        memories: [UserMemory],
        onChunk: ((String) -> Void)?
    ) async throws -> AIResponse {
        let systemPrompt = """
        You are Nova, an ultra-smart, minimalist executive AI assistant in the Aura (Memory AI) iOS app.
        Current date: \(Date().formatted(date: .complete, time: .shortened)).
        
        User Context:
        - Active Events Today: \(events.map { "\($0.title) at \($0.startDate.formatted(date: .omitted, time: .shortened))" }.joined(separator: ", "))
        - Active Habits: \(habits.map { "\($0.title) (\(Int($0.currentValue))/\(Int($0.targetValue)) \($0.unit))" }.joined(separator: ", "))
        - Long-term Memories: \(memories.prefix(5).map { $0.content }.joined(separator: " | "))
        
        Guidelines:
        - Be concise, elegant, respectful, and proactive.
        - Answer in the same language as the user (Vietnamese or English).
        - If the user wants to schedule an event, log a habit, save a memory, or plan a multi-step goal, fulfill their request and include an Action Tag at the very end of your response:
          - Event: [ACTION:event|Title|YYYY-MM-dd HH:mm]
          - Habit: [ACTION:habit|water/workout/medicine|amount]
          - Goal Plan: [ACTION:goal|Goal Title|Step 1;Step 2;Step 3;Step 4]
          - Memory: [ACTION:memory|Category|Note to remember]
        """
        
        let endpointURL: URL
        if selectedProvider == .gemini {
            let model = modelName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "gemini-1.5-flash" : modelName.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey.trimmingCharacters(in: .whitespacesAndNewlines))") else {
                throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Gemini endpoint URL"])
            }
            endpointURL = url
        } else {
            let urlString = selectedProvider == .custom && !customEndpoint.isEmpty ? customEndpoint : "https://api.openai.com/v1/chat/completions"
            endpointURL = URL(string: urlString)!
        }
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if selectedProvider == .gemini {
            let payload: [String: Any] = [
                "system_instruction": [
                    "parts": [["text": systemPrompt]]
                ],
                "contents": [
                    [
                        "role": "user",
                        "parts": [["text": query]]
                    ]
                ],
                "generationConfig": [
                    "temperature": 0.7,
                    "maxOutputTokens": 1000
                ]
            ]
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } else {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            let payload: [String: Any] = [
                "model": modelName.isEmpty ? "gpt-4o-mini" : modelName,
                "messages": [
                    ["role": "system", "content": systemPrompt],
                    ["role": "user", "content": query]
                ],
                "temperature": 0.7,
                "max_tokens": 500
            ]
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            var detailMsg = "HTTP Status \((response as? HTTPURLResponse)?.statusCode ?? -1)"
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errObj = json["error"] as? [String: Any],
               let msg = errObj["message"] as? String {
                detailMsg = msg
            }
            throw NSError(domain: "AIService", code: -1, userInfo: [NSLocalizedDescriptionKey: detailMsg])
        }
        
        var replyText = ""
        if selectedProvider == .gemini {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let candidates = json["candidates"] as? [[String: Any]],
               let firstCandidate = candidates.first,
               let contentObj = firstCandidate["content"] as? [String: Any],
               let parts = contentObj["parts"] as? [[String: Any]],
               let firstPart = parts.first,
               let text = firstPart["text"] as? String {
                replyText = text
            }
        } else {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let text = message["content"] as? String {
                replyText = text
            }
        }
        
        guard !replyText.isEmpty else {
            throw NSError(domain: "AIService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Empty AI response"])
        }
        
        onChunk?(replyText)
        
        // Parse and execute actions embedded in response
        return parseAndExecuteActionTags(from: replyText, in: context)
    }
    
    // MARK: - Action Tag Parser
    private func parseAndExecuteActionTags(from text: String, in context: ModelContext) -> AIResponse {
        var cleanContent = text
        var hasAction = false
        var actionTitle: String? = nil
        var actionType: String? = nil
        
        // Regex for [ACTION:type|param1|param2]
        let pattern = "\\[ACTION:(.*?)\\]"
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let nsText = text as NSString
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsText.length))
            
            for match in matches {
                let actionRaw = nsText.substring(with: match.range(at: 1))
                let parts = actionRaw.components(separatedBy: "|")
                cleanContent = cleanContent.replacingOccurrences(of: nsText.substring(with: match.range), with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard let kind = parts.first else { continue }
                
                switch kind.lowercased() {
                case "event":
                    let title = parts.count > 1 ? parts[1] : "Sự kiện mới"
                    let newEvent = AuraEvent(
                        title: title,
                        notes: "Tự động lên lịch bởi Nova AI",
                        startDate: Date().addingTimeInterval(3600),
                        endDate: Date().addingTimeInterval(7200),
                        category: "meeting"
                    )
                    context.insert(newEvent)
                    try? context.save()
                    hasAction = true
                    actionTitle = "Đã tạo sự kiện: \(title)"
                    actionType = "event_created"
                    
                case "habit":
                    let habitType = parts.count > 1 ? parts[1] : "water"
                    let amount = parts.count > 2 ? Double(parts[2]) ?? 1.0 : 1.0
                    hasAction = true
                    actionTitle = "Đã ghi nhận +\(Int(amount)) cho \(habitType)"
                    actionType = "habit_logged"
                    
                case "goal":
                    let goalTitle = parts.count > 1 ? parts[1] : "Mục tiêu mới"
                    let stepsStr = parts.count > 2 ? parts[2] : ""
                    let steps = stepsStr.components(separatedBy: ";").enumerated().map { idx, stepTitle in
                        GoalStep(stepIndex: idx + 1, title: stepTitle.trimmingCharacters(in: .whitespaces), detailDescription: "", isCompleted: false, estimatedTime: "30m")
                    }
                    let plan = GoalPlan(title: goalTitle, goalDescription: "Tạo bởi Nova Cloud LLM", category: "Kế hoạch", steps: steps.isEmpty ? [GoalStep(stepIndex: 1, title: "Bắt đầu", detailDescription: "", isCompleted: false, estimatedTime: "15m")] : steps)
                    context.insert(plan)
                    try? context.save()
                    hasAction = true
                    actionTitle = "Đã lập kế hoạch: \(goalTitle)"
                    actionType = "goal_plan_created"
                    
                case "memory":
                    let category = parts.count > 1 ? parts[1] : "general"
                    let note = parts.count > 2 ? parts[2] : ""
                    _ = MemoryService.shared.saveMemory(title: "Bài học từ Nova", content: note, category: category, in: context)
                    hasAction = true
                    actionTitle = "Đã lưu vào Bộ nhớ AI"
                    actionType = "memory_saved"
                    
                default:
                    break
                }
            }
        }
        
        return AIResponse(content: cleanContent, hasAction: hasAction, actionTitle: actionTitle, actionType: actionType)
    }
    
    // MARK: - Local Heuristic Engine (Deterministic & Zero Latency)
    private func processLocalQuery(
        _ query: String,
        in context: ModelContext,
        events: [AuraEvent],
        habits: [Habit],
        memories: [UserMemory]
    ) -> AIResponse {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let lower = trimmed.lowercased()
        
        // 1. HABIT LOGGING (Uống nước, Tập thể dục, Uống thuốc, Đo lường)
        if lower.contains("nước") || lower.contains("uống nước") || lower.contains("ly nước") || lower.contains("water") {
            let waterHabit = habits.first(where: { $0.categoryRaw == "water" })
            if let water = waterHabit {
                let amount = extractNumber(from: lower) ?? 1.0
                HabitService.shared.logProgress(for: water, amount: amount, in: context)
                return AIResponse(
                    content: "Tuyệt vời! Mình đã ghi nhận bạn vừa uống \(Int(amount)) \(water.unit) nước. Hôm nay bạn đã đạt \(Int(water.currentValue))/\(Int(water.targetValue)) \(water.unit) (Chuỗi \(water.streakDays) ngày liên tục 🔥).",
                    hasAction: true,
                    actionTitle: "Đã ghi nhận +\(Int(amount)) ly nước",
                    actionType: "habit_logged"
                )
            }
        }
        
        if lower.contains("tập") || lower.contains("thể dục") || lower.contains("chạy bộ") || lower.contains("gym") || lower.contains("workout") {
            let workoutHabit = habits.first(where: { $0.categoryRaw == "workout" })
            if let workout = workoutHabit {
                let minutes = extractNumber(from: lower) ?? 20.0
                HabitService.shared.logProgress(for: workout, amount: minutes, in: context)
                return AIResponse(
                    content: "Rất kỷ luật! Mình đã cộng thêm \(Int(minutes)) \(workout.unit) tập thể dục vào tiến độ hôm nay (\(Int(workout.currentValue))/\(Int(workout.targetValue)) \(workout.unit)). Hãy tiếp tục duy trì nhé!",
                    hasAction: true,
                    actionTitle: "Đã ghi nhận +\(Int(minutes)) phút tập",
                    actionType: "habit_logged"
                )
            }
        }
        
        if lower.contains("thuốc") || lower.contains("vitamin") || lower.contains("uống thuốc") {
            let medHabit = habits.first(where: { $0.categoryRaw == "medicine" })
            if let med = medHabit {
                HabitService.shared.logProgress(for: med, amount: 1.0, in: context)
                return AIResponse(
                    content: "Đã đánh dấu bạn đã uống thuốc/vitamin theo lịch hôm nay. Sức khỏe là ưu tiên số 1!",
                    hasAction: true,
                    actionTitle: "Đã hoàn thành cữ thuốc/vitamin",
                    actionType: "habit_logged"
                )
            }
        }
        
        // 2. LONG-TERM MEMORY & LEARNING (Ghi nhớ & Đính chính)
        if lower.contains("sửa lại") || lower.contains("đính chính") || lower.contains("nhầm rồi") || lower.contains("không phải") {
            _ = MemoryService.shared.saveMemory(
                title: "Đính chính từ người dùng",
                content: trimmed,
                category: "corrections",
                isCorrection: true,
                in: context
            )
            return AIResponse(
                content: "Cảm ơn bạn đã chỉ bảo! Mình đã ghi nhận đính chính này vào Bộ nhớ AI và sẽ điều chỉnh các câu trả lời sau này cho chuẩn xác hơn.",
                hasAction: true,
                actionTitle: "Đã cập nhật bài học mới",
                actionType: "memory_learned"
            )
        }
        
        if lower.contains("hãy nhớ") || lower.contains("ghi nhớ") || lower.contains("tôi thích") || lower.contains("sở thích") || lower.contains("dự án của tôi") || lower.contains("nhớ rằng") {
            let category: String
            if lower.contains("thích") || lower.contains("sở thích") {
                category = "preferences"
            } else if lower.contains("dự án") {
                category = "projects"
            } else if lower.contains("công việc") {
                category = "work"
            } else if lower.contains("gia đình") {
                category = "family"
            } else {
                category = "general"
            }
            
            _ = MemoryService.shared.saveMemory(
                title: "Ghi nhớ mới",
                content: trimmed,
                category: category,
                isCorrection: false,
                in: context
            )
            return AIResponse(
                content: "Mình đã lưu thông tin này vào Bộ nhớ Dài hạn của Nova (Mục: \(category)). Mình sẽ luôn cá nhân hóa các kế hoạch và câu trả lời dựa trên điều này!",
                hasAction: true,
                actionTitle: "Đã lưu vào Bộ nhớ AI",
                actionType: "memory_saved"
            )
        }
        
        // 3. MULTI-STEP GOALS (Kế hoạch đa bước)
        if lower.contains("chia nhỏ") || lower.contains("kế hoạch") || lower.contains("mục tiêu") || lower.contains("đa bước") || lower.contains("các bước") {
            let steps = [
                GoalStep(stepIndex: 1, title: "Nghiên cứu & Thu thập yêu cầu", detailDescription: "Tìm hiểu thông tin và các điều kiện tiên quyết", isCompleted: false, estimatedTime: "30m"),
                GoalStep(stepIndex: 2, title: "Phác thảo cấu trúc & Thiết kế", detailDescription: "Tạo khung sườn và phân chia việc cần làm", isCompleted: false, estimatedTime: "45m"),
                GoalStep(stepIndex: 3, title: "Thực thi bước ưu tiên cao nhất", detailDescription: "Tập trung giải quyết bước then chốt đầu tiên", isCompleted: false, estimatedTime: "1h"),
                GoalStep(stepIndex: 4, title: "Đánh giá kết quả & Tinh chỉnh", detailDescription: "So sánh với mục tiêu ban đầu và hoàn thiện", isCompleted: false, estimatedTime: "20m")
            ]
            let newPlan = GoalPlan(
                title: trimmed.replacingOccurrences(of: "Lập kế hoạch ", with: "").replacingOccurrences(of: "Chia nhỏ mục tiêu ", with: ""),
                goalDescription: "Kế hoạch đa bước được tạo tự động bởi Nova",
                category: "Kế hoạch",
                steps: steps
            )
            context.insert(newPlan)
            try? context.save()
            
            return AIResponse(
                content: "Mình đã phân rã mục tiêu lớn của bạn thành 4 bước hành động cụ thể. Bạn có thể mở tab Tasks để theo dõi từng bước:",
                hasAction: true,
                actionTitle: "Đã lập Kế hoạch 4 bước",
                actionType: "goal_plan_created"
            )
        }
        
        // 4. EVENT & REMINDERS (Sự kiện & Nhắc nhở)
        if lower.contains("họp") || lower.contains("meeting") || lower.contains("lịch") || lower.contains("hẹn") || lower.contains("deadline") || lower.contains("sinh nhật") {
            let cal = Calendar.current
            let tomorrow = cal.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            let startDate = cal.date(bySettingHour: 10, minute: 0, second: 0, of: tomorrow) ?? tomorrow
            let endDate = cal.date(byAdding: .hour, value: 1, to: startDate) ?? tomorrow
            
            let isAllDay = lower.contains("sinh nhật") || lower.contains("kỳ nghỉ") || lower.contains("lễ")
            let category = isAllDay ? "personal" : "meeting"
            
            let newEvent = AuraEvent(
                title: trimmed.replacingOccurrences(of: "Đặt lịch ", with: "").replacingOccurrences(of: "Tạo sự kiện ", with: ""),
                notes: "Tạo bởi Nova từ Chat",
                startDate: startDate,
                endDate: endDate,
                isAllDay: isAllDay,
                reminderMinutesBefore: 15,
                category: category
            )
            context.insert(newEvent)
            try? context.save()
            
            return AIResponse(
                content: "Đã lên lịch thành công cho bạn vào ngày mai lúc 10:00 AM. Sự kiện đã được đồng bộ vào Lịch Aura và chuẩn bị thông báo nhắc nhở trước 15 phút.",
                hasAction: true,
                actionTitle: "Đã tạo: \(newEvent.title)",
                actionType: "event_created"
            )
        }
        
        // 5. CAPABILITIES SUMMARY
        if lower.contains("làm được") || lower.contains("năng lực") || lower.contains("khả năng") || lower.contains("capabilities") {
            return AIResponse(
                content: """
                Dưới đây là những gì Nova có thể hỗ trợ bạn:
                
                📅 Sự kiện & Nhắc nhở: Lập lịch 1 lần/lặp lại, đặt nhắc trước 15m/1h, mời người tham gia, đồng bộ Apple Calendar.
                📊 Theo dõi Thói quen: Đếm lượng nước uống (ly), tập thể dục (phút), nhắc cữ thuốc/vitamin và theo dõi chuỗi ngày liên tục.
                🎯 Kế hoạch đa bước: Tự động phân rã các dự án lớn thành các bước hành động cụ thể.
                🧠 Bộ nhớ dài hạn: Ghi nhớ sở thích, dự án cá nhân và học hỏi từ những lần đính chính của bạn.
                ☀️ Daily Rhythms: Tự động gửi Morning Brief thời tiết, lịch trình và tin tức mỗi sáng.
                """,
                hasAction: true,
                actionTitle: "Xem danh mục Năng lực",
                actionType: "capabilities_viewed"
            )
        }
        
        // Default Helpful Response
        return AIResponse(
            content: "Mình đã ghi nhận yêu cầu của bạn vào Bộ nhớ Não bộ của Aura. Bạn có muốn mình đặt lịch nhắc nhở, lập kế hoạch đa bước hay theo dõi thói quen nào không?",
            hasAction: false,
            actionTitle: nil,
            actionType: nil
        )
    }
    
    private func extractNumber(from text: String) -> Double? {
        let pattern = "([0-9]+(?:\\.[0-9]+)?)"
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: text, range: NSRange(location: 0, length: text.utf16.count)),
           let range = Range(match.range(at: 1), in: text),
           let val = Double(text[range]) {
            return val
        }
        return nil
    }
}
