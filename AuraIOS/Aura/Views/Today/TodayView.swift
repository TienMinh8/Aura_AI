import SwiftUI
import SwiftData

struct TodayView: View {
    var onNavigateTab: (Int) -> Void
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AuraEvent.startDate) private var allEvents: [AuraEvent]
    @Query(sort: \Routine.hour) private var routines: [Routine]
    
    @State private var selectedDay: Int = Calendar.current.component(.day, from: Date())
    @State private var isTimelineView: Bool = false
    @State private var selectedDaysRange: Int = 1 // 1, 3, 7
    @State private var showCapabilitiesSheet: Bool = false
    @State private var showCalendarSyncSheet: Bool = false
    @State private var showAnalyticsSheet: Bool = false
    
    // Filters for layers menu (IMG_8729)
    @State private var showEventsFilter: Bool = true
    @State private var showGoogleFilter: Bool = true
    @State private var showAppleFilter: Bool = true
    @State private var showTasksFilter: Bool = true
    @State private var showRecordingsFilter: Bool = true
    @State private var showPostsFilter: Bool = true
    @State private var showAutomationsFilter: Bool = false
    
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
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Title & Layers Menu (IMG_8724, IMG_8729)
                    HStack {
                        Text("Oct 2026")
                            .font(.system(size: 34, weight: .bold, design: .serif))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        // Show / Layers Filter Menu (IMG_8729)
                        Menu {
                            Text("Show")
                            Toggle(isOn: $showEventsFilter) {
                                Label("Events", systemImage: "calendar")
                            }
                            Toggle(isOn: $showGoogleFilter) {
                                Label("Google", systemImage: "g.circle")
                            }
                            Toggle(isOn: $showAppleFilter) {
                                Label("Apple", systemImage: "apple.logo")
                            }
                            Toggle(isOn: $showTasksFilter) {
                                Label("Tasks", systemImage: "checklist")
                            }
                            Toggle(isOn: $showRecordingsFilter) {
                                Label("Recordings", systemImage: "waveform")
                            }
                            Toggle(isOn: $showPostsFilter) {
                                Label("Posts", systemImage: "paperplane")
                            }
                            Toggle(isOn: $showAutomationsFilter) {
                                Label("Automations", systemImage: "arrow.triangle.2.circlepath")
                            }
                        } label: {
                            Image(systemName: "square.3.layers.3d")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.white)
                                .padding(10)
                                .background(Circle().fill(Color.auraCard))
                                .overlay(Circle().stroke(Color.auraBorder, lineWidth: 0.8))
                        }
                    }
                    .padding(.top, 16)
                    
                    // Weekly Date Strip
                    weeklyStrip
                    
                    // Main View (Events List or Timeline)
                    if isTimelineView {
                        timelineView
                    } else {
                        if eventsForSelectedDay.isEmpty {
                            emptyStateCard
                        } else {
                            VStack(spacing: 16) {
                                eventsList
                                
                                // Sub link at bottom of list
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
                                .padding(.top, 4)
                            }
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
    
    private var displayedDays: [(name: String, day: Int)] {
        if isTimelineView && selectedDaysRange == 3 {
            return [("TU", 6), ("WE", 7), ("TH", 8)]
        } else if isTimelineView && selectedDaysRange == 7 {
            return [("MO", 5), ("TU", 6), ("WE", 7), ("TH", 8), ("FR", 9), ("SA", 10), ("SU", 11)]
        } else {
            return days
        }
    }
    
    // MARK: - Weekly Date Strip
    private var weeklyStrip: some View {
        HStack(spacing: 8) {
            ForEach(displayedDays, id: \.day) { item in
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
                Text("Nothing planned today")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Ask the chat to plan it — or add one below.")
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
                    Text("Add event")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 28)
                .padding(.vertical, 12)
                .background(Capsule().fill(Color.auraAmber))
                .shadow(color: Color.auraAmber.opacity(0.35), radius: 10, y: 4)
            }
            .padding(.top, 6)
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
    
    // MARK: - Timeline View (IMG_8724, IMG_8725, IMG_8727)
    private var timelineView: some View {
        let hours = ["2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM"]
        
        return ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                ForEach(hours, id: \.self) { hourStr in
                    HStack(alignment: .top, spacing: 12) {
                        Text(hourStr)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundStyle(Color.auraTextMuted)
                            .frame(width: 44, alignment: .leading)
                        
                        VStack(spacing: 0) {
                            Divider()
                                .background(Color.white.opacity(0.08))
                            Spacer()
                        }
                    }
                    .frame(height: 56)
                }
            }
            
            // Vertical Column Dividers for 3-Day or 7-Day view (IMG_8725, IMG_8727)
            if selectedDaysRange > 1 {
                GeometryReader { geo in
                    let colWidth = (geo.size.width - 56) / CGFloat(selectedDaysRange)
                    HStack(spacing: 0) {
                        Spacer().frame(width: 56)
                        ForEach(0..<selectedDaysRange, id: \.self) { i in
                            Rectangle()
                                .fill(Color.white.opacity(0.06))
                                .frame(width: 0.6)
                            if i < selectedDaysRange - 1 {
                                Spacer().frame(width: colWidth)
                            }
                        }
                    }
                }
            }
            
            // Current Time Indicator (e.g. 3:35 PM - IMG_8724)
            HStack(spacing: 0) {
                Spacer().frame(width: 40)
                Circle()
                    .fill(Color.auraAmber)
                    .frame(width: 10, height: 10)
                    .shadow(color: Color.auraAmber.opacity(0.6), radius: 4)
                
                Rectangle()
                    .fill(Color.auraAmber)
                    .frame(height: 1.5)
            }
            .offset(y: 88) // Around 3:35 PM
        }
        .padding(.top, 10)
    }
    
    // MARK: - Bottom Floating Controls (Capsule Switcher + Plus Button)
    private var bottomControls: some View {
        HStack(alignment: .center) {
            // Mode Switcher Capsule (IMG_8721, IMG_8724)
            HStack(spacing: 4) {
                // List Mode Button
                Button {
                    AuraHaptic.selection()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isTimelineView = false
                    }
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(!isTimelineView ? .black : .white.opacity(0.7))
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(!isTimelineView ? .white : .clear))
                }
                
                // Grid/Timeline Mode Button
                Button {
                    AuraHaptic.selection()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isTimelineView = true
                    }
                } label: {
                    Image(systemName: "calendar")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(isTimelineView ? .black : .white.opacity(0.7))
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(isTimelineView ? .white : .clear))
                }
                
                // 1 | 3 | 7 Day Range Switcher (IMG_8724, IMG_8725)
                if isTimelineView {
                    Rectangle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 1, height: 18)
                        .padding(.horizontal, 2)
                    
                    ForEach([1, 3, 7], id: \.self) { range in
                        Button {
                            AuraHaptic.selection()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedDaysRange = range
                            }
                        } label: {
                            Text("\(range)")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundStyle(selectedDaysRange == range ? .black : .white.opacity(0.7))
                                .frame(width: 28, height: 28)
                                .background(Circle().fill(selectedDaysRange == range ? .white : .clear))
                        }
                    }
                }
            }
            .padding(4)
            .background(
                Capsule()
                    .fill(Color(red: 0.12, green: 0.12, blue: 0.14).opacity(0.95))
                    .overlay(Capsule().stroke(Color.white.opacity(0.12), lineWidth: 0.8))
            )
            
            Spacer()
            
            // Amber Plus Button (IMG_8724, IMG_8727)
            Menu {
                Button {
                    onNavigateTab(0)
                } label: {
                    Label("Reminder", systemImage: "bell.fill")
                }
                
                Button {
                    onNavigateTab(2)
                } label: {
                    Label("Task", systemImage: "arrow.triangle.2.circlepath")
                }
                
                Button {
                    onNavigateTab(0)
                } label: {
                    Label("Post", systemImage: "paperplane.fill")
                }
                
                Button {
                    onNavigateTab(0)
                } label: {
                    Label("Recording", systemImage: "waveform")
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(width: 52, height: 52)
                    .background(Circle().fill(Color.auraAmber))
                    .shadow(color: Color.auraAmber.opacity(0.4), radius: 10, y: 4)
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
