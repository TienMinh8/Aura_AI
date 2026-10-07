import Foundation
import SwiftData

@Model
public final class AuraEvent {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var notes: String
    public var startDate: Date
    public var endDate: Date
    public var isAllDay: Bool
    public var reminderMinutesBefore: Int?
    public var category: String
    public var calendarEventIdentifier: String?
    public var isCompleted: Bool
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        startDate: Date,
        endDate: Date,
        isAllDay: Bool = false,
        reminderMinutesBefore: Int? = 15,
        category: String = "general",
        calendarEventIdentifier: String? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.startDate = startDate
        self.endDate = endDate
        self.isAllDay = isAllDay
        self.reminderMinutesBefore = reminderMinutesBefore
        self.category = category
        self.calendarEventIdentifier = calendarEventIdentifier
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}

// MARK: - Sample Data
extension AuraEvent {
    public static var samples: [AuraEvent] {
        let cal = Calendar.current
        let today = Date()
        
        let e1Start = cal.date(bySettingHour: 9, minute: 0, second: 0, of: today) ?? today
        let e1End = cal.date(byAdding: .minute, value: 45, to: e1Start) ?? today
        
        let e2Start = cal.date(bySettingHour: 11, minute: 30, second: 0, of: today) ?? today
        let e2End = cal.date(byAdding: .hour, value: 1, to: e2Start) ?? today
        
        let e3Start = cal.date(bySettingHour: 15, minute: 0, second: 0, of: today) ?? today
        let e3End = cal.date(byAdding: .minute, value: 90, to: e3Start) ?? today
        
        let e4Start = cal.date(bySettingHour: 18, minute: 0, second: 0, of: today) ?? today
        let e4End = cal.date(byAdding: .hour, value: 1, to: e4Start) ?? today
        
        return [
            AuraEvent(title: "Morning Standup & Sync", notes: "Review Sprint 1 items and unblock team", startDate: e1Start, endDate: e1End, category: "work"),
            AuraEvent(title: "Product Design Review", notes: "Audit OLED UI with design lead", startDate: e2Start, endDate: e2End, category: "meeting"),
            AuraEvent(title: "Focus Block: Core iOS Engine", notes: "SwiftData + EventKit integration", startDate: e3Start, endDate: e3End, category: "focus"),
            AuraEvent(title: "Gym & Stretching", notes: "Upper body session", startDate: e4Start, endDate: e4End, category: "health")
        ]
    }
}
