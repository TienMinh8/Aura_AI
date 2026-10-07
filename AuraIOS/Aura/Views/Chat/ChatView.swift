import SwiftUI
import SwiftData

struct ChatView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChatMessage.timestamp, order: .forward) private var messages: [ChatMessage]
    @Query(sort: \AuraEvent.startDate) private var allEvents: [AuraEvent]
    @Query private var habits: [Habit]
    @Query private var memories: [UserMemory]
    
    @State private var inputText: String = ""
    @State private var selectedChip: String = "Capabilities"
    @State private var showUsageSheet: Bool = false
    @State private var isAIThinking: Bool = false
    
    private var speechService = SpeechService.shared
    
    let suggestionChips = [
        ("newspaper", "News"),
        ("cloud.rain", "Weather"),
        ("leaf.fill", "Motivation"),
        ("chart.line.uptrend.xyaxis", "Price"),
        ("sparkles", "Capabilities")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Nova Capsule
            topHeader
            
            // Suggestion Chips
            chipsScrollView
                .padding(.vertical, 8)
            
            // Chat Content Scroll
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Today")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.auraTextMuted)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 4)
                        
                        ForEach(messages) { msg in
                            if msg.role == "user" {
                                userMessageBubble(msg)
                                    .id(msg.id)
                            } else {
                                novaMessageBubble(msg)
                                    .id(msg.id)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 90) // Floating Bar spacing
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: messages.count) { _, _ in
                    if let last = messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Bottom Input Bar
            chatInputBar
                .padding(.horizontal, 16)
                .padding(.bottom, 80) // Above Floating Tab Bar
        }
        .background(Color.auraBackground.ignoresSafeArea())
    }
    
    // MARK: - Top Header Capsule
    private var topHeader: some View {
        HStack {
            Spacer()
            
            Button {
                AuraHaptic.selection()
                showUsageSheet = true
            } label: {
                HStack(spacing: 8) {
                    // Online Green Dot or Recording Red Dot
                    Circle()
                        .fill(speechService.isRecording ? Color.red : Color.auraSuccess)
                        .frame(width: 8, height: 8)
                    
                    VStack(spacing: 1) {
                        Text("Nova")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text(speechService.isRecording ? "Listening..." : (isAIThinking ? "Gemini is thinking..." : (AIService.shared.selectedProvider == .gemini ? "Gemini AI · Active" : "Memory AI · Active")))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(speechService.isRecording ? Color.auraAmber : Color.auraTextSecondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.auraCard)
                        .overlay(
                            Capsule()
                                .stroke(speechService.isRecording ? Color.auraAmber : Color.auraBorder, lineWidth: 0.8)
                        )
                )
            }
            .buttonStyle(.plain)
            
            Spacer()
        }
        .padding(.top, 8)
        .sheet(isPresented: $showUsageSheet) {
            UsageSheet()
        }
    }
    
    // MARK: - Chips
    private var chipsScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(suggestionChips, id: \.1) { icon, title in
                    let isSelected = selectedChip == title
                    
                    Button {
                        AuraHaptic.selection()
                        selectedChip = title
                        handleChipTapped(title)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: icon)
                                .font(.system(size: 12))
                            Text(title)
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundStyle(isSelected ? .black : .white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(isSelected ? Color.auraAmber : Color.auraCard)
                                .overlay(
                                    Capsule()
                                        .stroke(isSelected ? Color.clear : Color.auraBorder, lineWidth: 0.8)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Nova Message Bubble
    private func novaMessageBubble(_ msg: ChatMessage) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(msg.content)
                .font(.system(size: 14.5, weight: .regular))
                .foregroundStyle(.white.opacity(0.92))
                .lineSpacing(4)
            
            if msg.hasAction, let title = msg.actionTitle {
                HStack(spacing: 8) {
                    Image(systemName: actionIcon(for: msg.actionType))
                        .foregroundStyle(actionColor(for: msg.actionType))
                        .font(.system(size: 13))
                    
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(actionColor(for: msg.actionType))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(actionColor(for: msg.actionType).opacity(0.12))
                        .overlay(Capsule().stroke(actionColor(for: msg.actionType).opacity(0.4), lineWidth: 0.8))
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.auraCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.auraBorder, lineWidth: 0.8)
                )
        )
    }
    
    private func actionIcon(for actionType: String?) -> String {
        switch actionType {
        case "habit_logged": return "flame.fill"
        case "memory_learned", "memory_saved": return "brain.head.profile"
        case "goal_plan_created": return "target"
        case "service_required": return "exclamationmark.triangle.fill"
        default: return "checkmark.circle.fill"
        }
    }
    
    private func actionColor(for actionType: String?) -> Color {
        switch actionType {
        case "habit_logged": return Color.orange
        case "memory_learned": return Color.auraSuccess
        case "service_required": return Color.yellow
        default: return Color.auraAmber
        }
    }
    
    // MARK: - User Message Bubble
    private func userMessageBubble(_ msg: ChatMessage) -> some View {
        HStack {
            Spacer()
            
            Text(msg.content)
                .font(.system(size: 14.5, weight: .medium))
                .foregroundStyle(.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.auraAmber)
                )
        }
    }
    
    // MARK: - Input Bar
    private var chatInputBar: some View {
        HStack(spacing: 12) {
            Button {
                AuraHaptic.selection()
                inputText = "Đặt lịch họp với team lúc 10h sáng mai"
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.auraTextSecondary)
            }
            
            Button {
                AuraHaptic.selection()
                inputText = "Hôm nay tôi có những lịch gì?"
            } label: {
                Image(systemName: "at")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.auraTextSecondary)
            }
            
            TextField("Nhắn cho Nova hoặc ghi nhận việc...", text: $inputText)
                .font(.system(size: 15))
                .foregroundStyle(.white)
                .onSubmit {
                    sendMessage()
                }
            
            if inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Button {
                    handleVoiceRecordTapped()
                } label: {
                    ZStack {
                        if speechService.isRecording {
                            Circle()
                                .stroke(Color.auraAmber.opacity(0.4), lineWidth: 2)
                                .frame(width: 28, height: 28)
                                .scaleEffect(1.0 + speechService.audioLevel * 0.6)
                                .animation(.easeOut(duration: 0.15), value: speechService.audioLevel)
                        }
                        
                        Image(systemName: speechService.isRecording ? "waveform" : "mic.fill")
                            .font(.system(size: 17))
                            .foregroundStyle(speechService.isRecording ? Color.auraAmber : Color.auraTextSecondary)
                    }
                }
            } else {
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(Color.auraAmber)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.auraCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(speechService.isRecording ? Color.auraAmber.opacity(0.5) : Color.auraBorder, lineWidth: 0.8)
                )
        )
    }
    
    // MARK: - Actions
    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        if speechService.isRecording {
            speechService.stopRecording()
        }
        
        AuraHaptic.medium()
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        let userMsg = ChatMessage(role: "user", content: text)
        modelContext.insert(userMsg)
        inputText = ""
        isAIThinking = true
        
        // Intelligent Assistant Logic via AIService (Async Cloud / Local Engine)
        Task {
            let res = await AIService.shared.processQueryAsync(
                text,
                in: modelContext,
                events: allEvents,
                habits: habits,
                memories: memories
            )
            
            await MainActor.run {
                isAIThinking = false
                let reply = ChatMessage(
                    role: "assistant",
                    content: res.content,
                    hasAction: res.hasAction,
                    actionTitle: res.actionTitle,
                    actionType: res.actionType
                )
                modelContext.insert(reply)
                AuraHaptic.success()
                try? modelContext.save()
            }
        }
    }
    
    private func handleChipTapped(_ chip: String) {
        switch chip {
        case "News":
            inputText = "Có tin tức hay cập nhật gì mới hôm nay?"
            sendMessage()
        case "Weather":
            inputText = "Thời tiết hôm nay thế nào?"
            sendMessage()
        case "Motivation":
            inputText = "Cho tôi một lời khuyên tạo động lực hôm nay"
            sendMessage()
        case "Price":
            inputText = "Cập nhật giá vàng hoặc thị trường tài chính hôm nay"
            sendMessage()
        case "Capabilities", "Năng lực Nova":
            inputText = "Nova có thể làm được những gì?"
            sendMessage()
        case "Uống 2 ly nước":
            inputText = "Tôi vừa uống 2 ly nước"
            sendMessage()
        case "Tập 30 phút":
            inputText = "Tôi vừa chạy bộ tập thể dục 30 phút"
            sendMessage()
        case "Kế hoạch 4 bước":
            inputText = "Lập kế hoạch ra mắt ứng dụng Aura"
            sendMessage()
        case "Ghi nhớ sở thích":
            inputText = "Hãy nhớ rằng tôi thích uống Americano không đường"
            sendMessage()
        case "Đặt lịch họp":
            inputText = "Đặt lịch họp chiến lược vào 10:00 sáng mai"
            sendMessage()
        default:
            break
        }
    }
    
    private func handleVoiceRecordTapped() {
        AuraHaptic.medium()
        if speechService.isRecording {
            speechService.stopRecording()
        } else {
            speechService.startRecording { recognized in
                self.inputText = recognized
            }
        }
    }
}
