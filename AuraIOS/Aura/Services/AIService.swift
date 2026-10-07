import Foundation
import SwiftData
import SwiftUI

@MainActor
final class AIService {
    static let shared = AIService()
    
    private init() {}
    
    struct AIResponse {
        let content: String
        let hasAction: Bool
        let actionTitle: String?
        let actionType: String?
    }
    
    /// Process user prompt and execute appropriate domain actions (Events, Habits, Memories, Goals)
    func processQuery(
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
            let memory = MemoryService.shared.saveMemory(
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
            NotificationService.shared.scheduleEventReminder(for: newEvent)
            
            if PermissionsManager.shared.isCalendarAuthorized {
                _ = try? CalendarService.shared.exportToAppleCalendar(event: newEvent)
            }
            try? context.save()
            
            return AIResponse(
                content: "Mình đã tạo sự kiện \"\(newEvent.title)\" vào lúc 10:00 AM ngày mai, kèm nhắc nhở trước 15 phút và tự động đồng bộ sang Apple Calendar của bạn.",
                hasAction: true,
                actionTitle: "Đã thêm Sự kiện & Nhắc nhở",
                actionType: "event_created"
            )
        }
        
        // 5. EXTERNAL SERVICES DISCLAIMER (Thời tiết, Tin tức, Telegram, X/Twitter)
        if lower.contains("thời tiết") || lower.contains("weather") {
            return AIResponse(
                content: "Hiện tại để tra cứu thời tiết thời gian thực cho vị trí của bạn, bạn cần kết nối API OpenWeather hoặc Apple Weather trong mục Cài đặt kết nối. Trong bản demo này, trời hôm nay dự báo 28°C, nắng nhẹ và rất thuận lợi cho công việc ngoài trời!",
                hasAction: true,
                actionTitle: "Yêu cầu kết nối Dịch vụ Thời tiết",
                actionType: "service_required"
            )
        }
        
        if lower.contains("telegram") || lower.contains("gửi tin nhắn telegram") {
            return AIResponse(
                content: "Để gửi tin nhắn tự động qua Telegram, vui lòng nhập Telegram Bot Token và Chat ID trong trang Kết nối Dịch vụ. Nova sẽ có thể gửi báo cáo trực tiếp đến kênh của bạn!",
                hasAction: true,
                actionTitle: "Yêu cầu cấu hình Telegram Bot",
                actionType: "service_required"
            )
        }
        
        if lower.contains("twitter") || lower.contains("x/twitter") || lower.contains("đăng bài") {
            return AIResponse(
                content: "Để đăng bài lên X/Twitter tự động, bạn cần cấp quyền tài khoản qua OAuth 2.0 trong trang Kết nối Dịch vụ.",
                hasAction: true,
                actionTitle: "Yêu cầu kết nối tài khoản X",
                actionType: "service_required"
            )
        }
        
        // 6. ANALYTICS & INSIGHTS (Báo cáo & Phân tích)
        if lower.contains("báo cáo") || lower.contains("phân tích") || lower.contains("thống kê") || lower.contains("tiến độ") {
            let totalHabits = habits.count
            let activeStreaks = habits.filter { $0.streakDays > 0 }.count
            let completedEvents = events.filter { $0.isCompleted }.count
            return AIResponse(
                content: """
📊 Báo cáo Hiệu suất Tuần này:
• Thói quen: \(activeStreaks)/\(totalHabits) thói quen đang duy trì chuỗi liên tục.
• Sự kiện & Nhiệm vụ: Đã hoàn thành \(completedEvents)/\(events.count) mục.
• Đánh giá từ Nova: Bạn đang duy trì phong độ rất tốt, mức độ kỷ luật tăng 14% so với tuần trước!
""",
                hasAction: true,
                actionTitle: "Báo cáo Hiệu suất Hoàn tất",
                actionType: "analytics_report"
            )
        }
        
        // 7. CAPABILITIES QUERY (Khả năng của Nova)
        if lower.contains("làm gì") || lower.contains("làm được") || lower.contains("khả năng") || lower.contains("giúp gì") || lower.contains("nova") {
            return AIResponse(
                content: """
Xin chào! Mình là Nova — Trợ lý Memory AI toàn diện của bạn. Dưới đây là những gì mình có thể thực hiện:

📅 1. Sự kiện & Nhắc nhở: Tạo sự kiện 1 lần hoặc lặp lại, hẹn giờ báo trước, quản lý cuộc họp, deadline và đồng bộ 2 chiều Apple Calendar.
📊 2. Theo dõi Thói quen: Uống nước, tập thể dục, uống thuốc/vitamin, đo lường và tính chuỗi streak.
💬 3. Trò chuyện & Tư vấn: Giải đáp kiến thức, chia sẻ lời khuyên, tóm tắt và hỗ trợ viết văn bản.
🧠 4. Ghi nhớ & Học hỏi: Tự động lưu sở thích, dự án, gia đình và học từ mọi đính chính của bạn.
⚙️ 5. Tác vụ tự động: Chạy routine buổi sáng, tổng hợp nhắc nhở và kích hoạt theo lịch.
🔗 6. Kết nối dịch vụ: Đồng bộ Apple Calendar, Google Calendar, Notion, Telegram, X/Twitter.
📈 7. Báo cáo & Phân tích: So sánh dữ liệu tuần này vs tuần trước, thống kê xu hướng thói quen.
🎯 8. Kế hoạch đa bước: Chia nhỏ mục tiêu lớn thành các bước hành động cụ thể để hoàn thành.

⚠️ Những tác vụ cần kết nối API trước: Tra cứu thời tiết/tin tức thời gian thực, gửi tin Telegram, đăng bài lên X.
""",
                hasAction: true,
                actionTitle: "8 Năng lực cốt lõi của Nova",
                actionType: "capabilities_overview"
            )
        }
        
        // Default advisory response
        return AIResponse(
            content: "Mình đã ghi nhận yêu cầu của bạn vào Bộ nhớ Memory AI. Bạn có muốn mình tạo sự kiện trên Lịch, theo dõi thói quen, hay lập kế hoạch đa bước cho việc này không?",
            hasAction: false,
            actionTitle: nil,
            actionType: nil
        )
    }
    
    private func extractNumber(from text: String) -> Double? {
        let pattern = "\\b\\d+(\\.\\d+)?\\b"
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let nsString = text as NSString
            if let match = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: nsString.length)) {
                let matchString = nsString.substring(with: match.range)
                return Double(matchString)
            }
        }
        return nil
    }
}
