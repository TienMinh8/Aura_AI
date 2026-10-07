import SwiftUI
import SwiftData

struct TodayView: View {
    var onNavigateTab: (Int) -> Void
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AuraEvent.startDate) private var allEvents: [AuraEvent]
    @Query(sort: \Routine.hour) private var routines: [Routine]
    
    @State private var selectedDay: Int = Calendar.current.component(.day, from: Date())
    @State private var isTimelineView: Bool = false
    @State private var showCapabilitiesSheet: Bool = false
    @State private var showCalendarSyncSheet: Bool = false
    @State private var showAnalyticsSheet: Bool = false
    @State private var isSyncing: Bool = false
    
    let days: [(name: String, day: Int)] = [
        ("SA", 3), ("SU", 4), ("MO", 5), ("TU", 6),
        ("WE", 7), ("TH", 8), ("FR", 9)
    ]
    
    // Filter events for today/selected day
    private var eventsForSelectedDay: [AuraEvent] {
        return allEvents.filter { event in
            let day = Calendar.current.component(.day, from: event.startDate)
            return day == selectedDay
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Title & View Toggle
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Oct 2026")
                                .font(.system(size: 32, weight: .bold, design: .serif))
                                .foregroundStyle(.white)
                            
                            Text("\(allEvents.count) items tracked in Aura")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.auraTextMuted)
                        }
                        
                        Spacer()
                        
                        // Calendar Sync Quick Button
                        Button {
                            AuraHaptic.selection()
                            showCalendarSyncSheet = true
                        } label: {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.auraAmber)
                                .padding(10)
                                .background(Circle().fill(Color.auraCard))
                                .overlay(Circle().stroke(Color.auraBorder, lineWidth: 0.8))
                        }
                        
                        // View Switcher (List vs Grid/Timeline)
                        Button {
                            AuraHaptic.selection()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                isTimelineView.toggle()
                            }
                        } label: {
                            Image(systemName: isTimelineView ? "list.bullet" : "square.3.layers.3d")
                                .font(.system(size: 16))
                                .foregroundStyle(isTimelineView ? Color.auraAmber : Color.white)
                                .padding(10)
                                .background(Circle().fill(Color.auraCard))
                                .overlay(Circle().stroke(Color.auraBorder, lineWidth: 0.8))
                        }
                    }
                    .padding(.top, 16)
                    
                    // Weekly Date Strip
                    weeklyStrip
                    
                    // Habits Tracker Section (Nova Năng lực #2)
                    HabitsTrackerSection {
                        showAnalyticsSheet = true
                    }
                    
                    // Routines Horizontal Scroll Strip
                    routinesStrip
                    
                    // Main View (Events List or Timeline)
                    if isTimelineView {
                        timelineView
                    } else {
                        if eventsForSelectedDay.isEmpty {
                            emptyStateCard
                        } else {
                            eventsList
                        }
                    }
                    
                    Spacer(minLength: 120) // Floating bar spacing
                }
                .padding(.horizontal, 16)
            }
            
            // Bottom Action Controls
            bottomControls
                .padding(.horizontal, 16)
                .padding(.bottom, 90)
        }
        .background(Color.auraBackground.ignoresSafeArea())
        .sheet(isPresented: $showCapabilitiesSheet) {
            CapabilitiesSheet()
        }
        .sheet(isPresented: $showCalendarSyncSheet) {
            CalendarSyncSheet()
        }
        .sheet(isPresented: $showAnalyticsSheet) {
            AnalyticsReportSheet()
        }
    }
    
    // MARK: - Weekly Date Strip
    private var weeklyStrip: some View {
        HStack(spacing: 8) {
            ForEach(days, id: \.day) { item in
                let isSelected = selectedDay == item.day
                
                Button {
                    AuraHaptic.selection()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedDay = item.day
                    }
                } label: {
                    VStack(spacing: 6) {
                        Text(item.name)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(isSelected ? Color.auraAmber : Color.auraTextMuted)
                        
                        Text("\(item.day)")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(isSelected ? .black : .white)
                            .frame(width: 38, height: 38)
                            .background(
                                Circle()
                                    .fill(isSelected ? Color.auraAmber : Color.clear)
                                    .shadow(color: isSelected ? Color.auraAmber.opacity(0.4) : .clear, radius: 8)
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 6)
    }
    
    // MARK: - Routines Strip
    private var routinesStrip: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("DAILY RHYTHMS")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.auraTextMuted)
                    .tracking(1.2)
                
                Spacer()
                
                Text("\(routines.filter { $0.isEnabled }.count) Active")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.auraAmber)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(routines) { routine in
                        HStack(spacing: 8) {
                            Image(systemName: routine.iconName)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color.auraAmber)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(routine.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(.white)
                                
                                Text(routine.timeString)
                                    .font(.system(size: 10))
                                    .foregroundStyle(Color.auraTextSecondary)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(routine.isEnabled ? Color.auraCard : Color.white.opacity(0.03))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(routine.isEnabled ? Color.auraBorder : Color.white.opacity(0.04), lineWidth: 0.8)
                                )
                        )
                        .opacity(routine.isEnabled ? 1.0 : 0.6)
                        .onTapGesture {
                            AuraHaptic.selection()
                            routine.isEnabled.toggle()
                            if routine.isEnabled {
                                NotificationService.shared.scheduleRoutine(for: routine)
                            } else {
                                NotificationService.shared.cancelNotification(identifier: routine.notificationIdentifier)
                            }
                            try? modelContext.save()
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Events List
    private var eventsList: some View {
        VStack(spacing: 12) {
            ForEach(eventsForSelectedDay) { event in
                HStack(spacing: 14) {
                    // Checkbox button
                    Button {
                        AuraHaptic.medium()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            event.isCompleted.toggle()
                            try? modelContext.save()
                        }
                    } label: {
                        Image(systemName: event.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 22))
                            .foregroundStyle(event.isCompleted ? Color.auraSuccess : Color.auraTextMuted)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(event.isCompleted ? Color.auraTextMuted : .white)
                            .strikethrough(event.isCompleted, color: Color.auraTextMuted)
                        
                        HStack(spacing: 8) {
                            Text(formatTime(event.startDate))
                                .font(.system(size: 12, weight: .medium, design: .monospaced))
                                .foregroundStyle(Color.auraAmber)
                            
                            if !event.notes.isEmpty {
                                Text("·  " + event.notes)
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.auraTextSecondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Category pill
                    Text(event.category.uppercased())
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(categoryColor(event.category))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(categoryColor(event.category).opacity(0.15)))
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.auraCard)
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.auraBorder, lineWidth: 0.8))
                )
            }
        }
    }
    
    // MARK: - Empty State Card
    private var emptyStateCard: some View {
        VStack(spacing: 20) {
            HStack(spacing: 12) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.auraAmber)
                    .padding(8)
                    .background(Circle().fill(Color.white.opacity(0.08)))
                
                VStack(alignment: .leading, spacing: 4) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 80, height: 6)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 50, height: 6)
                }
                
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.auraSuccess)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.auraCard)
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.auraBorder, lineWidth: 0.8))
            )
            .padding(.horizontal, 24)
            .padding(.top, 40)
            
            VStack(spacing: 8) {
                Text("Nothing planned for day \(selectedDay)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Ask Nova chat to plan it — or sync with your Apple Calendar.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.auraTextSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Add Event Primary CTA
            Button {
                AuraHaptic.medium()
                onNavigateTab(0) // Go to Chat
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: 15, weight: .bold))
                    Text("Ask Nova to plan")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Capsule().fill(Color.auraAmber))
                .shadow(color: Color.auraAmber.opacity(0.35), radius: 10, y: 4)
            }
            .padding(.top, 6)
            
            // Sub Link
            Button {
                showCapabilitiesSheet = true
            } label: {
                HStack(spacing: 8) {
                    Text("☀️🥛📜")
                    Text("What else Memory can do")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.85))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.auraTextMuted)
                }
                .padding(.vertical, 8)
            }
            .padding(.top, 12)
        }
    }
    
    // MARK: - Timeline View
    private var timelineView: some View {
        VStack(spacing: 10) {
            ForEach(8..<20) { hour in
                let hourEvents = eventsForSelectedDay.filter {
                    Calendar.current.component(.hour, from: $0.startDate) == hour
                }
                
                HStack(alignment: .top, spacing: 14) {
                    Text(String(format: "%02d:00", hour))
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(Color.auraTextMuted)
                        .frame(width: 50, alignment: .leading)
                    
                    if hourEvents.isEmpty {
                        VStack {
                            Divider()
                                .background(Color.white.opacity(0.08))
                            Spacer()
                        }
                    } else {
                        VStack(spacing: 6) {
                            ForEach(hourEvents) { ev in
                                HStack {
                                    Text(ev.title)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Text(formatTime(ev.startDate))
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundStyle(Color.auraAmber)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.auraCard)
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.auraAmber.opacity(0.3), lineWidth: 0.8))
                                )
                            }
                        }
                    }
                }
                .frame(minHeight: 48)
            }
        }
        .padding(.top, 16)
    }
    
    // MARK: - Bottom Floating Action Button
    private var bottomControls: some View {
        HStack {
            Spacer()
            
            Menu {
                Button {
                    onNavigateTab(0)
                } label: {
                    Label("Add Event with Nova", systemImage: "calendar.badge.plus")
                }
                
                Button {
                    showCalendarSyncSheet = true
                } label: {
                    Label("Sync Apple Calendar", systemImage: "arrow.triangle.2.circlepath")
                }
                
                Button {
                    onNavigateTab(2)
                } label: {
                    Label("View Tasks", systemImage: "checklist")
                }
                
                Button {
                    onNavigateTab(0)
                } label: {
                    Label("Quick Voice Note", systemImage: "mic.fill")
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(width: 54, height: 54)
                    .background(Circle().fill(Color.auraAmber))
                    .shadow(color: Color.auraAmber.opacity(0.4), radius: 12, y: 5)
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    private func categoryColor(_ category: String) -> Color {
        switch category.lowercased() {
        case "work", "meeting": return Color.auraAmber
        case "focus": return Color(red: 0.65, green: 0.55, blue: 0.98)
        case "health": return Color(red: 0.2, green: 0.8, blue: 0.4)
        default: return Color.white.opacity(0.8)
        }
    }
}
