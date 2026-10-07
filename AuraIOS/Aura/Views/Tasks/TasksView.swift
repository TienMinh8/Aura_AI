import SwiftUI
import SwiftData

struct TasksView: View {
    var onNavigateTab: (Int) -> Void
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Routine.hour) private var routines: [Routine]
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @Query(sort: \GoalPlan.createdAt, order: .reverse) private var goalPlans: [GoalPlan]
    
    @State private var showCapabilitiesSheet: Bool = false
    @State private var showGoalPlansSheet: Bool = false
    @State private var showHabitsSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("Tasks")
                        .font(.system(size: 34, weight: .bold, design: .serif))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Menu {
                        Button {
                            onNavigateTab(0)
                        } label: {
                            Label("New Routine with Nova", systemImage: "sparkles")
                        }
                        
                        Button {
                            showGoalPlansSheet = true
                        } label: {
                            Label("Multi-step Goal Plans", systemImage: "target")
                        }
                        
                        Button {
                            showHabitsSheet = true
                        } label: {
                            Label("Habits & Streaks", systemImage: "flame.fill")
                        }
                        
                        Divider()
                        
                        Button {
                            showCapabilitiesSheet = true
                        } label: {
                            Label("What Nova can do", systemImage: "lightbulb.fill")
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.auraAmber)
                            .padding(10)
                            .background(Circle().fill(Color.auraCard))
                            .overlay(Circle().stroke(Color.auraBorder, lineWidth: 0.8))
                    }
                }
                .padding(.top, 16)
                
                // Routines Section (Clock + List)
                routinesSection
                
                // Bottom link
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
                
                Spacer(minLength: 120)
            }
            .padding(.horizontal, 16)
        }
        .background(Color.auraBackground.ignoresSafeArea())
        .sheet(isPresented: $showCapabilitiesSheet) {
            CapabilitiesSheet()
        }
        .sheet(isPresented: $showGoalPlansSheet) {
            NavigationStack {
                ZStack {
                    Color.auraBackground.ignoresSafeArea()
                    ScrollView {
                        goalPlansSection
                            .padding(16)
                    }
                }
                .navigationTitle("Goal Plans")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .sheet(isPresented: $showHabitsSheet) {
            NavigationStack {
                ZStack {
                    Color.auraBackground.ignoresSafeArea()
                    ScrollView {
                        habitsListSection
                            .padding(16)
                    }
                }
                .navigationTitle("Habits Tracker")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    // MARK: - Routines Section (Tác vụ tự động)
    private var routinesSection: some View {
        VStack(spacing: 20) {
            // Retro Analog Clock Hero
            RetroAlarmClockView()
                .frame(width: 140, height: 140)
                .padding(.vertical, 8)
            
            // Titles
            VStack(spacing: 6) {
                Text("Let Nova take on the routine")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Turn one on — it'll arrive by itself, every day.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.auraTextSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Routine Cards Container
            VStack(spacing: 0) {
                ForEach(Array(routines.enumerated()), id: \.element.id) { index, routine in
                    if index > 0 {
                        dividerLine
                    }
                    
                    routineRow(routine: routine)
                }
                
                if !routines.isEmpty {
                    dividerLine
                }
                
                // Something else row (matching reference IMG_8728)
                Button {
                    AuraHaptic.selection()
                    onNavigateTab(0)
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.auraAmber)
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(Color.white.opacity(0.06)))
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Something else")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                            
                            Text("Describe it in chat — Nova will set it up")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.auraTextSecondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.auraTextMuted)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.plain)
            }
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.auraCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.auraBorder, lineWidth: 0.8)
                    )
            )
        }
    }
    
    // MARK: - Goal Plans Section (🎯 Kế hoạch đa bước)
    private var goalPlansSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Kế hoạch đa bước")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                Text("Nova chia nhỏ các mục tiêu lớn thành các bước hành động rõ ràng.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.auraTextSecondary)
            }
            
            GoalPlansSectionView()
        }
    }
    
    // MARK: - Habits List Section (📊 Thói quen)
    private var habitsListSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Quản lý Thói quen")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                Text("Theo dõi lượng nước, thể dục, thuốc, đo lường và chuỗi ngày liên tục.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.auraTextSecondary)
            }
            
            VStack(spacing: 12) {
                ForEach(habits) { habit in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: habit.categoryIcon)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(Color.auraAmber)
                                .frame(width: 40, height: 40)
                                .background(Circle().fill(Color.auraAmberSoft))
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text(habit.title)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                                
                                Text("\(Int(habit.currentValue)) / \(Int(habit.targetValue)) \(habit.unit)")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.auraTextSecondary)
                            }
                            
                            Spacer()
                            
                            if habit.streakDays > 0 {
                                HStack(spacing: 4) {
                                    Image(systemName: "flame.fill")
                                        .font(.system(size: 11))
                                        .foregroundStyle(.orange)
                                    Text("\(habit.streakDays) ngày liên tục")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(.orange)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(Color.orange.opacity(0.15)))
                            }
                        }
                        
                        // Progress bar
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.08))
                                    .frame(height: 8)
                                Capsule()
                                    .fill(habit.isGoalAchieved ? Color.auraSuccess : Color.auraAmber)
                                    .frame(width: geo.size.width * CGFloat(habit.progressRatio), height: 8)
                            }
                        }
                        .frame(height: 8)
                        
                        // Action buttons
                        HStack {
                            Text(habit.notes.isEmpty ? "Cập nhật mỗi ngày" : habit.notes)
                                .font(.system(size: 11))
                                .foregroundStyle(Color.auraTextMuted)
                            
                            Spacer()
                            
                            Button {
                                AuraHaptic.selection()
                                HabitService.shared.decrementProgress(for: habit, amount: habit.categoryRaw == "workout" ? 10 : 1, in: modelContext)
                            } label: {
                                Image(systemName: "minus")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(Color.auraTextMuted)
                                    .frame(width: 28, height: 28)
                                    .background(Circle().fill(Color.white.opacity(0.06)))
                            }
                            
                            Button {
                                AuraHaptic.medium()
                                HabitService.shared.logProgress(for: habit, amount: habit.categoryRaw == "workout" ? 10 : 1, in: modelContext)
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(.black)
                                    .frame(width: 28, height: 28)
                                    .background(Circle().fill(Color.auraAmber))
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.auraCard)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(habit.isGoalAchieved ? Color.auraSuccess.opacity(0.4) : Color.auraBorder, lineWidth: 0.8)
                            )
                    )
                }
            }
        }
    }
    
    // MARK: - Routine Row (IMG_8728)
    private func routineRow(routine: Routine) -> some View {
        HStack(spacing: 14) {
            Image(systemName: routine.iconName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.auraAmber)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(white: 0.15))
                )
            
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text(routine.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Text(routine.timeString)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color.auraTextSecondary)
                }
                
                Text(routine.subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.auraTextMuted)
            }
            
            Spacer()
            
            // Sleek "Turn on" / "Active" pill button (IMG_8728)
            Button {
                AuraHaptic.selection()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    routine.isEnabled.toggle()
                    if routine.isEnabled {
                        NotificationService.shared.scheduleRoutine(for: routine)
                    } else {
                        NotificationService.shared.cancelNotification(identifier: routine.notificationIdentifier)
                    }
                    try? modelContext.save()
                }
            } label: {
                Text(routine.isEnabled ? "Active" : "Turn on")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(routine.isEnabled ? Color.auraAmber : .white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(routine.isEnabled ? Color.auraAmber.opacity(0.18) : Color(white: 0.22))
                            .overlay(
                                Capsule().stroke(routine.isEnabled ? Color.auraAmber.opacity(0.4) : Color.clear, lineWidth: 0.8)
                            )
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
    
    private var dividerLine: some View {
        Rectangle()
            .fill(Color.auraBorder)
            .frame(height: 0.6)
            .padding(.leading, 74)
    }
}

// MARK: - Retro Alarm Clock Hero View
struct RetroAlarmClockView: View {
    var body: some View {
        ZStack {
            // Twin Bell Ears
            HStack(spacing: 70) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.auraAmber, Color(red: 0.7, green: 0.4, blue: 0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                    .offset(y: -44)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.auraAmber, Color(red: 0.7, green: 0.4, blue: 0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                    .offset(y: -44)
            }
            
            // Top handle & hammer
            Capsule()
                .fill(Color.auraAmber)
                .frame(width: 24, height: 6)
                .offset(y: -48)
            
            // Legs
            HStack(spacing: 66) {
                Capsule()
                    .fill(Color.auraAmber.opacity(0.8))
                    .frame(width: 8, height: 20)
                    .rotationEffect(.degrees(-25))
                    .offset(y: 46)
                
                Capsule()
                    .fill(Color.auraAmber.opacity(0.8))
                    .frame(width: 8, height: 20)
                    .rotationEffect(.degrees(25))
                    .offset(y: 46)
            }
            
            // Main Clock Body
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(red: 0.15, green: 0.15, blue: 0.18), Color(red: 0.08, green: 0.08, blue: 0.1)],
                        center: .center,
                        startRadius: 5,
                        endRadius: 55
                    )
                )
                .frame(width: 104, height: 104)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.auraAmber, Color.auraAmber.opacity(0.3)],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 3
                        )
                )
                .shadow(color: Color.auraAmber.opacity(0.3), radius: 12, x: 0, y: 4)
            
            // Hour Markers
            ForEach(0..<12) { i in
                Rectangle()
                    .fill(i % 3 == 0 ? Color.auraAmber : Color.white.opacity(0.35))
                    .frame(width: i % 3 == 0 ? 2.5 : 1.5, height: i % 3 == 0 ? 8 : 5)
                    .offset(y: -42)
                    .rotationEffect(.degrees(Double(i) * 30))
            }
            
            // Hour Hand (Pointing around 10:10)
            Capsule()
                .fill(Color.white)
                .frame(width: 3.5, height: 26)
                .offset(y: -13)
                .rotationEffect(.degrees(-60))
            
            // Minute Hand
            Capsule()
                .fill(Color.auraAmber)
                .frame(width: 2.5, height: 36)
                .offset(y: -18)
                .rotationEffect(.degrees(50))
            
            // Center Pivot
            Circle()
                .fill(Color.auraAmber)
                .frame(width: 8, height: 8)
                .overlay(Circle().stroke(Color.black, lineWidth: 1.5))
        }
        .frame(width: 130, height: 130)
    }
}
