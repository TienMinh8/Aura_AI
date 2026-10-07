import Foundation
import SwiftUI
import EventKit
import UserNotifications
import AVFoundation
import Speech

@Observable
public final class PermissionsManager {
    public static let shared = PermissionsManager()
    
    public var isCalendarAuthorized: Bool = false
    public var isRemindersAuthorized: Bool = false
    public var isNotificationAuthorized: Bool = false
    public var isMicrophoneAuthorized: Bool = false
    public var isSpeechAuthorized: Bool = false
    
    private let eventStore = EKEventStore()
    
    private init() {
        checkAllStatuses()
    }
    
    // MARK: - Check Status
    public func checkAllStatuses() {
        checkCalendarStatus()
        checkRemindersStatus()
        checkNotificationStatus()
        checkMicrophoneStatus()
        checkSpeechStatus()
    }
    
    public func checkCalendarStatus() {
        let status = EKEventStore.authorizationStatus(for: .event)
        if #available(iOS 17.0, *) {
            isCalendarAuthorized = (status == .fullAccess)
        } else {
            isCalendarAuthorized = (status == .authorized)
        }
    }
    
    public func checkRemindersStatus() {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        if #available(iOS 17.0, *) {
            isRemindersAuthorized = (status == .fullAccess)
        } else {
            isRemindersAuthorized = (status == .authorized)
        }
    }
    
    public func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isNotificationAuthorized = (settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional)
            }
        }
    }
    
    public func checkMicrophoneStatus() {
        if #available(iOS 17.0, *) {
            switch AVAudioApplication.shared.recordPermission {
            case .granted:
                isMicrophoneAuthorized = true
            default:
                isMicrophoneAuthorized = false
            }
        } else {
            switch AVAudioSession.sharedInstance().recordPermission {
            case .granted:
                isMicrophoneAuthorized = true
            default:
                isMicrophoneAuthorized = false
            }
        }
    }
    
    public func checkSpeechStatus() {
        isSpeechAuthorized = (SFSpeechRecognizer.authorizationStatus() == .authorized)
    }
    
    // MARK: - Request Permissions
    
    @MainActor
    public func requestCalendarAccess() async -> Bool {
        do {
            if #available(iOS 17.0, *) {
                let granted = try await eventStore.requestFullAccessToEvents()
                self.isCalendarAuthorized = granted
                return granted
            } else {
                let granted = try await eventStore.requestAccess(to: .event)
                self.isCalendarAuthorized = granted
                return granted
            }
        } catch {
            print("❌ Failed requesting calendar access: \(error.localizedDescription)")
            self.isCalendarAuthorized = false
            return false
        }
    }
    
    @MainActor
    public func requestRemindersAccess() async -> Bool {
        do {
            if #available(iOS 17.0, *) {
                let granted = try await eventStore.requestFullAccessToReminders()
                self.isRemindersAuthorized = granted
                return granted
            } else {
                let granted = try await eventStore.requestAccess(to: .reminder)
                self.isRemindersAuthorized = granted
                return granted
            }
        } catch {
            print("❌ Failed requesting reminders access: \(error.localizedDescription)")
            self.isRemindersAuthorized = false
            return false
        }
    }
    
    @MainActor
    public func requestNotificationAccess() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            self.isNotificationAuthorized = granted
            return granted
        } catch {
            print("❌ Failed requesting notification access: \(error.localizedDescription)")
            self.isNotificationAuthorized = false
            return false
        }
    }
    
    @MainActor
    public func requestMicrophoneAccess() async -> Bool {
        if #available(iOS 17.0, *) {
            let granted = await AVAudioApplication.requestRecordPermission()
            self.isMicrophoneAuthorized = granted
            return granted
        } else {
            return await withCheckedContinuation { continuation in
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    DispatchQueue.main.async {
                        self.isMicrophoneAuthorized = granted
                        continuation.resume(returning: granted)
                    }
                }
            }
        }
    }
    
    @MainActor
    public func requestSpeechAccess() async -> Bool {
        return await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                DispatchQueue.main.async {
                    let granted = (status == .authorized)
                    self.isSpeechAuthorized = granted
                    continuation.resume(returning: granted)
                }
            }
        }
    }
    
    // MARK: - Open Settings
    public func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
