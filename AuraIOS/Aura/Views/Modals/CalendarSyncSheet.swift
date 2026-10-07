import SwiftUI
import SwiftData
import EventKit

struct CalendarSyncSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(PermissionsManager.self) private var permissions
    
    @State private var exportToApple: Bool = true
    @State private var importFromApple: Bool = true
    @State private var syncGoogle: Bool = false
    @State private var isSyncing: Bool = false
    @State private var syncResultBanner: String? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Sync Status Banner
                    HStack(spacing: 12) {
                        Image(systemName: permissions.isCalendarAuthorized ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(permissions.isCalendarAuthorized ? Color.auraSuccess : Color.auraAmber)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(permissions.isCalendarAuthorized ? "Calendar Access Granted" : "Calendar Access Required")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.white)
                            
                            Text(permissions.isCalendarAuthorized ? "Two-way sync is active with Apple Calendar" : "Allow Aura access to read and schedule your events")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.auraTextSecondary)
                        }
                        
                        Spacer()
                        
                        if !permissions.isCalendarAuthorized {
                            Button("Grant") {
                                AuraHaptic.medium()
                                Task {
                                    _ = await permissions.requestCalendarAccess()
                                }
                            }
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color.auraAmber))
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.auraCard)
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(permissions.isCalendarAuthorized ? Color.auraSuccess.opacity(0.3) : Color.auraAmber.opacity(0.3), lineWidth: 1))
                    )
                    
                    // Sync Now Action Card
                    if permissions.isCalendarAuthorized {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Manual Synchronization")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                                
                                Text("Pull latest changes from iCloud Calendar")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.auraTextSecondary)
                            }
                            
                            Spacer()
                            
                            Button {
                                performSync()
                            } label: {
                                HStack(spacing: 6) {
                                    if isSyncing {
                                        ProgressView()
                                            .tint(.black)
                                    } else {
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                            .font(.system(size: 13, weight: .bold))
                                        Text("Sync Now")
                                            .font(.system(size: 13, weight: .bold))
                                    }
                                }
                                .foregroundStyle(.black)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(Color.auraAmber))
                            }
                            .disabled(isSyncing)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.auraCard)
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.auraBorder, lineWidth: 0.8))
                        )
                    }
                    
                    // Feedback Banner
                    if let banner = syncResultBanner {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(Color.auraAmber)
                            Text(banner)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.auraAmberSoft))
                    }
                    
                    // Apple Calendar Sync Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.auraAmber)
                            
                            Text("Apple Calendar")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        
                        Divider().background(Color.white.opacity(0.08))
                        
                        // Export Row
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Export to Calendar")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                                
                                Text("Aura ➔ Calendar")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(Color.auraAmber)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Capsule().fill(Color.auraAmberSoft))
                                
                                Spacer()
                                
                                Toggle("", isOn: $exportToApple)
                                    .labelsHidden()
                                    .tint(Color.auraAmber)
                            }
                            
                            Text("Sync your Memory AI reminders directly to your Apple Calendar.")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.auraTextSecondary)
                        }
                        
                        Divider().background(Color.white.opacity(0.06))
                        
                        // Import Row
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Import from Calendar")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                                
                                Text("Calendar ➔ Aura")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(Color.white.opacity(0.8))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Capsule().fill(Color.white.opacity(0.1)))
                                
                                Spacer()
                                
                                Toggle("", isOn: $importFromApple)
                                    .labelsHidden()
                                    .tint(Color.auraAmber)
                            }
                            
                            Text("Import events and meetings from Apple Calendar into Nova assistant.")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.auraTextSecondary)
                        }
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.auraCard)
                            .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.auraBorder, lineWidth: 0.8))
                    )
                    
                    // Google Calendar
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Google Calendar")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                            
                            Text("OAuth integration available in Phase 4")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.auraTextSecondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $syncGoogle)
                            .labelsHidden()
                            .tint(Color.auraAmber)
                            .disabled(true)
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.auraCard)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.auraBorder, lineWidth: 0.8))
                    )
                }
                .padding(16)
            }
            .background(Color.auraBackground.ignoresSafeArea())
            .navigationTitle("Calendars")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(Color.auraAmber)
                    .font(.system(size: 15, weight: .semibold))
                }
            }
        }
    }
    
    private func performSync() {
        AuraHaptic.medium()
        isSyncing = true
        syncResultBanner = nil
        
        Task {
            do {
                let count = try await CalendarService.shared.syncAppleCalendarToSwiftData(context: modelContext)
                await MainActor.run {
                    isSyncing = false
                    AuraHaptic.success()
                    syncResultBanner = "Successfully synchronized \(count) events with Apple Calendar."
                }
            } catch {
                await MainActor.run {
                    isSyncing = false
                    AuraHaptic.error()
                    syncResultBanner = "Sync error: \(error.localizedDescription)"
                }
            }
        }
    }
}
