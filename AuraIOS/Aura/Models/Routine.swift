import Foundation
import SwiftData

@Model
public final class Routine {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var subtitle: String
    public var timeString: String
    public var hour: Int
    public var minute: Int
    public var isEnabled: Bool
    public var iconName: String
    public var colorHex: String
    public var notificationIdentifier: String
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        subtitle: String,
        timeString: String,
        hour: Int,
        minute: Int,
        isEnabled: Bool = true,
        iconName: String,
        colorHex: String = "#FFB020",
        notificationIdentifier: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.timeString = timeString
        self.hour = hour
        self.minute = minute
        self.isEnabled = isEnabled
        self.iconName = iconName
        self.colorHex = colorHex
        self.notificationIdentifier = notificationIdentifier.isEmpty ? "routine_\(id.uuidString)" : notificationIdentifier
        self.createdAt = createdAt
    }
}

// MARK: - Default Presets
extension Routine {
    public static var defaultRoutines: [Routine] {
        return [
            Routine(
                name: "Morning Brief",
                subtitle: "Weather, priorities & calendar outlook",
                timeString: "8:00 AM",
                hour: 8,
                minute: 0,
                isEnabled: true,
                iconName: "sun.horizon.fill",
                colorHex: "#FFB020"
            ),
            Routine(
                name: "Midday Reset",
                subtitle: "Hydration check, posture & quick breath",
                timeString: "1:30 PM",
                hour: 13,
                minute: 30,
                isEnabled: true,
                iconName: "cup.and.saucer.fill",
                colorHex: "#00E5FF"
            ),
            Routine(
                name: "Deep Focus Session",
                subtitle: "Silence notifications & start 90m block",
                timeString: "3:00 PM",
                hour: 15,
                minute: 0,
                isEnabled: false,
                iconName: "brain.head.profile",
                colorHex: "#A78BFA"
            ),
            Routine(
                name: "Evening Review",
                subtitle: "Unfinished tasks triage & tomorrow's plan",
                timeString: "6:30 PM",
                hour: 18,
                minute: 30,
                isEnabled: true,
                iconName: "moon.stars.fill",
                colorHex: "#34D399"
            ),
            Routine(
                name: "Night Reflection",
                subtitle: "Journaling highlight of the day & gratitude",
                timeString: "10:00 PM",
                hour: 22,
                minute: 0,
                isEnabled: true,
                iconName: "bed.double.fill",
                colorHex: "#F472B6"
            )
        ]
    }
}
