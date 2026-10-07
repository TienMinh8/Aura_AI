import Foundation
import SwiftData

@Model
public final class ChatMessage {
    @Attribute(.unique) public var id: UUID
    public var role: String // "user" or "assistant"
    public var content: String
    public var timestamp: Date
    public var hasAction: Bool
    public var actionTitle: String?
    public var actionType: String?
    
    public init(
        id: UUID = UUID(),
        role: String,
        content: String,
        timestamp: Date = Date(),
        hasAction: Bool = false,
        actionTitle: String? = nil,
        actionType: String? = nil
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
        self.hasAction = hasAction
        self.actionTitle = actionTitle
        self.actionType = actionType
    }
}

// MARK: - Sample Chat History
extension ChatMessage {
    public static var samples: [ChatMessage] {
        return [
            ChatMessage(
                role: "assistant",
                content: "Good morning Alex. You have 3 events today and your Morning Brief routine is scheduled in 25 minutes. How can I help you?",
                timestamp: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date()
            ),
            ChatMessage(
                role: "user",
                content: "Sync my Apple Calendar and prepare today's agenda.",
                timestamp: Calendar.current.date(byAdding: .minute, value: -45, to: Date()) ?? Date()
            ),
            ChatMessage(
                role: "assistant",
                content: "I've synchronized 4 calendar events and adjusted your focus block to 3:00 PM to avoid overlapping meetings.",
                timestamp: Calendar.current.date(byAdding: .minute, value: -44, to: Date()) ?? Date(),
                hasAction: true,
                actionTitle: "4 Events Synced",
                actionType: "calendar_sync"
            )
        ]
    }
}
