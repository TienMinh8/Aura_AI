import Foundation
import SwiftData

@Model
public final class ConnectedApp {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var appType: String // "apple_calendar", "google_calendar", "telegram", "notion"
    public var iconName: String
    public var isConnected: Bool
    public var lastSyncDate: Date?
    public var accountName: String?
    public var syncCount: Int
    
    public init(
        id: UUID = UUID(),
        name: String,
        appType: String,
        iconName: String,
        isConnected: Bool = false,
        lastSyncDate: Date? = nil,
        accountName: String? = nil,
        syncCount: Int = 0
    ) {
        self.id = id
        self.name = name
        self.appType = appType
        self.iconName = iconName
        self.isConnected = isConnected
        self.lastSyncDate = lastSyncDate
        self.accountName = accountName
        self.syncCount = syncCount
    }
}

// MARK: - Default Integrations
extension ConnectedApp {
    public static var defaultApps: [ConnectedApp] {
        return [
            ConnectedApp(
                name: "Apple Calendar",
                appType: "apple_calendar",
                iconName: "calendar",
                isConnected: true,
                lastSyncDate: Date(),
                accountName: "iCloud Sync Active",
                syncCount: 24
            ),
            ConnectedApp(
                name: "Google Calendar",
                appType: "google_calendar",
                iconName: "globe",
                isConnected: false,
                lastSyncDate: nil,
                accountName: nil,
                syncCount: 0
            ),
            ConnectedApp(
                name: "Telegram Bot",
                appType: "telegram",
                iconName: "paperplane.fill",
                isConnected: false,
                lastSyncDate: nil,
                accountName: nil,
                syncCount: 0
            ),
            ConnectedApp(
                name: "Notion Workspace",
                appType: "notion",
                iconName: "doc.text.fill",
                isConnected: false,
                lastSyncDate: nil,
                accountName: nil,
                syncCount: 0
            )
        ]
    }
}
