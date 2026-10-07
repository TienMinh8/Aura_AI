import Foundation
import EventKit
import SwiftData

public final class CalendarService {
    public static let shared = CalendarService()
    
    private let eventStore = EKEventStore()
    
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCalendarChangeNotification),
            name: .EKEventStoreChanged,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleCalendarChangeNotification() {
        print("🔔 Apple Calendar database changed externally")
        NotificationCenter.default.post(name: NSNotification.Name("AuraExternalCalendarChanged"), object: nil)
    }
    
    // MARK: - Fetch Events from Apple Calendar
    public func fetchEvents(from startDate: Date, to endDate: Date) -> [EKEvent] {
        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        return eventStore.events(matching: predicate).sorted { $0.startDate < $1.startDate }
    }
    
    // MARK: - Sync from Apple Calendar to SwiftData
    @MainActor
    public func syncAppleCalendarToSwiftData(context: ModelContext) async throws -> Int {
        // Ensure access first
        let hasAccess = await PermissionsManager.shared.requestCalendarAccess()
        guard hasAccess else {
            throw NSError(domain: "CalendarService", code: 403, userInfo: [NSLocalizedDescriptionKey: "Calendar permission not granted"])
        }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 7, to: startOfDay) ?? Date()
        
        let appleEvents = fetchEvents(from: startOfDay, to: endOfWeek)
        
        // Fetch existing Aura events to match by identifier
        let descriptor = FetchDescriptor<AuraEvent>()
        let existingEvents = (try? context.fetch(descriptor)) ?? []
        let existingMap = Dictionary(grouping: existingEvents.compactMap { e in e.calendarEventIdentifier.map { ($0, e) } }, by: { $0.0 })
            .compactMapValues { $0.first?.1 }
        
        var importedCount = 0
        
        for ekEvent in appleEvents {
            guard let ekId = ekEvent.eventIdentifier else { continue }
            
            if let existing = existingMap[ekId] {
                // Update existing
                existing.title = ekEvent.title ?? "Untitled"
                existing.notes = ekEvent.notes ?? ""
                existing.startDate = ekEvent.startDate
                existing.endDate = ekEvent.endDate
                existing.isAllDay = ekEvent.isAllDay
            } else {
                // Insert new
                let newEvent = AuraEvent(
                    title: ekEvent.title ?? "Untitled Event",
                    notes: ekEvent.notes ?? "",
                    startDate: ekEvent.startDate,
                    endDate: ekEvent.endDate,
                    isAllDay: ekEvent.isAllDay,
                    category: ekEvent.isAllDay ? "all-day" : "calendar",
                    calendarEventIdentifier: ekId
                )
                context.insert(newEvent)
                importedCount += 1
                
                // Schedule local notification if desired
                NotificationService.shared.scheduleEventReminder(for: newEvent)
            }
        }
        
        try context.save()
        return importedCount
    }
    
    // MARK: - Export Aura Event to Apple Calendar
    public func exportToAppleCalendar(event: AuraEvent) throws -> String {
        let ekEvent: EKEvent
        if let existingId = event.calendarEventIdentifier,
           let found = eventStore.event(withIdentifier: existingId) {
            ekEvent = found
        } else {
            ekEvent = EKEvent(eventStore: eventStore)
            ekEvent.calendar = eventStore.defaultCalendarForNewEvents
        }
        
        ekEvent.title = event.title
        ekEvent.notes = event.notes
        ekEvent.startDate = event.startDate
        ekEvent.endDate = event.endDate
        ekEvent.isAllDay = event.isAllDay
        
        if let minutesBefore = event.reminderMinutesBefore {
            ekEvent.alarms = [EKAlarm(relativeOffset: -Double(minutesBefore * 60))]
        }
        
        try eventStore.save(ekEvent, span: .thisEvent, commit: true)
        event.calendarEventIdentifier = ekEvent.eventIdentifier
        return ekEvent.eventIdentifier ?? ""
    }
    
    // MARK: - Remove Event from Apple Calendar
    public func deleteFromAppleCalendar(identifier: String) throws {
        if let ekEvent = eventStore.event(withIdentifier: identifier) {
            try eventStore.remove(ekEvent, span: .thisEvent, commit: true)
        }
    }
}
