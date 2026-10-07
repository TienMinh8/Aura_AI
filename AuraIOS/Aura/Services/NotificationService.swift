import Foundation
import UserNotifications

public final class NotificationService {
    public static let shared = NotificationService()
    
    public enum Category {
        public static let eventReminder = "AURA_EVENT_REMINDER"
        public static let routineReminder = "AURA_ROUTINE_REMINDER"
    }
    
    public enum Action {
        public static let markDone = "MARK_DONE"
        public static let snooze15 = "SNOOZE_15"
        public static let openChat = "OPEN_CHAT"
        public static let startRoutine = "START_ROUTINE"
    }
    
    private init() {
        registerCategories()
    }
    
    // MARK: - Register Interactive Notification Categories
    public func registerCategories() {
        let markDoneAction = UNNotificationAction(
            identifier: Action.markDone,
            title: "Mark Done",
            options: [.authenticationRequired]
        )
        
        let snoozeAction = UNNotificationAction(
            identifier: Action.snooze15,
            title: "Snooze 15m",
            options: []
        )
        
        let chatAction = UNNotificationAction(
            identifier: Action.openChat,
            title: "Open Nova Chat",
            options: [.foreground]
        )
        
        let startRoutineAction = UNNotificationAction(
            identifier: Action.startRoutine,
            title: "Start Routine",
            options: [.foreground]
        )
        
        let eventCategory = UNNotificationCategory(
            identifier: Category.eventReminder,
            actions: [markDoneAction, snoozeAction, chatAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        let routineCategory = UNNotificationCategory(
            identifier: Category.routineReminder,
            actions: [startRoutineAction, snoozeAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([eventCategory, routineCategory])
    }
    
    // MARK: - Schedule Event Reminder
    public func scheduleEventReminder(for event: AuraEvent) {
        guard let minutesBefore = event.reminderMinutesBefore, minutesBefore >= 0 else { return }
        
        let reminderDate = Calendar.current.date(byAdding: .minute, value: -minutesBefore, to: event.startDate) ?? event.startDate
        guard reminderDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Aura · \(event.title)"
        if minutesBefore == 0 {
            content.body = "Starting now. " + (event.notes.isEmpty ? "Tap to view details." : event.notes)
        } else {
            content.body = "Starts in \(minutesBefore) minutes. " + (event.notes.isEmpty ? "" : event.notes)
        }
        content.sound = .default
        content.categoryIdentifier = Category.eventReminder
        content.userInfo = [
            "eventId": event.id.uuidString,
            "type": "event_reminder"
        ]
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let identifier = "event_\(event.id.uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed scheduling event reminder: \(error.localizedDescription)")
            } else {
                print("✅ Scheduled event reminder for: \(event.title) at \(reminderDate)")
            }
        }
    }
    
    // MARK: - Schedule Routine
    public func scheduleRoutine(for routine: Routine) {
        let identifier = routine.notificationIdentifier
        
        // Remove old schedule first
        cancelNotification(identifier: identifier)
        
        guard routine.isEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Aura · \(routine.name)"
        content.body = routine.subtitle
        content.sound = .default
        content.categoryIdentifier = Category.routineReminder
        content.userInfo = [
            "routineId": routine.id.uuidString,
            "type": "routine"
        ]
        
        var dateComponents = DateComponents()
        dateComponents.hour = routine.hour
        dateComponents.minute = routine.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed scheduling routine: \(error.localizedDescription)")
            } else {
                print("✅ Scheduled recurring routine: \(routine.name) at \(routine.timeString)")
            }
        }
    }
    
    // MARK: - Snooze Helper
    public func snoozeNotification(identifier: String, title: String, body: String, delayMinutes: Double = 15) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Snoozed: \(body)"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delayMinutes * 60, repeats: false)
        let request = UNNotificationRequest(identifier: "snooze_\(identifier)_\(Date().timeIntervalSince1970)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Cancel
    public func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
    public func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
