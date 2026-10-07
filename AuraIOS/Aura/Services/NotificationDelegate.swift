import Foundation
import UserNotifications

public final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    public static let shared = NotificationDelegate()
    
    // Callback when user taps an action (e.g. Snooze or Open Chat)
    public var onOpenChatRequested: ((String?) -> Void)?
    public var onMarkDoneRequested: ((String) -> Void)?
    
    private override init() {
        super.init()
    }
    
    // MARK: - Foreground Presentation
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show banner, play sound, and update badge even while app is foregrounded
        completionHandler([.banner, .sound, .badge, .list])
    }
    
    // MARK: - Handle Action Response
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        let eventId = userInfo["eventId"] as? String
        
        switch response.actionIdentifier {
        case NotificationService.Action.markDone:
            if let eventId = eventId {
                print("⚡️ User marked event done: \(eventId)")
                onMarkDoneRequested?(eventId)
            }
            
        case NotificationService.Action.snooze15:
            let title = response.notification.request.content.title
            let body = response.notification.request.content.body
            NotificationService.shared.snoozeNotification(
                identifier: response.notification.request.identifier,
                title: title,
                body: body,
                delayMinutes: 15
            )
            print("⏱ Snoozed notification for 15 minutes")
            
        case NotificationService.Action.openChat, NotificationService.Action.startRoutine:
            print("💬 Opening Chat from notification")
            onOpenChatRequested?(eventId)
            
        case UNNotificationDefaultActionIdentifier:
            // Tapped notification body directly
            print("📱 User tapped notification")
            onOpenChatRequested?(eventId)
            
        default:
            break
        }
        
        completionHandler()
    }
}
