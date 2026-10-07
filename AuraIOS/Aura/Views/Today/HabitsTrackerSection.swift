import SwiftUI
import SwiftData

struct HabitsTrackerSection: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    
    var onOpenAnalytics: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("THEO DÕI THÓI QUEN")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.auraTextMuted)
                    .tracking(1.2)
                
                Spacer()
                
                Button {
                    AuraHaptic.selection()
                    onOpenAnalytics()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chart.bar.xaxis")
                        Text("Báo cáo tuần")
                    }
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.auraAmber)
                }
            }
            
            // Grid of habit cards (2 columns)
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                ForEach(habits) { habit in
                    habitCard(for: habit)
                }
            }
        }
        .padding(.vertical, 6)
    }
    
    @ViewBuilder
    private func habitCard(for habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: habit.categoryIcon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.auraAmber)
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(Color.auraAmberSoft))
                
                Spacer()
                
                // Streak badge
                if habit.streakDays > 0 {
                    HStack(spacing: 3) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.orange)
                        Text("\(habit.streakDays)d")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.orange)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color.orange.opacity(0.15)))
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text("\(Int(habit.currentValue)) / \(Int(habit.targetValue)) \(habit.unit)")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.auraTextSecondary)
            }
            
            // Progress Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 6)
                    
                    Capsule()
                        .fill(habit.isGoalAchieved ? Color.auraSuccess : Color.auraAmber)
                        .frame(width: geo.size.width * CGFloat(habit.progressRatio), height: 6)
                }
            }
            .frame(height: 6)
            
            // Increment / Decrement Controls
            HStack {
                Button {
                    AuraHaptic.selection()
                    HabitService.shared.decrementProgress(for: habit, amount: habit.categoryRaw == "workout" ? 10 : 1, in: modelContext)
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.auraTextMuted)
                        .frame(width: 26, height: 26)
                        .background(Circle().fill(Color.white.opacity(0.05)))
                }
                
                Spacer()
                
                Button {
                    AuraHaptic.medium()
                    HabitService.shared.logProgress(for: habit, amount: habit.categoryRaw == "workout" ? 10 : 1, in: modelContext)
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.black)
                        .frame(width: 26, height: 26)
                        .background(Circle().fill(Color.auraAmber))
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.auraCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(habit.isGoalAchieved ? Color.auraSuccess.opacity(0.4) : Color.auraBorder, lineWidth: 0.8)
                )
        )
    }
}
