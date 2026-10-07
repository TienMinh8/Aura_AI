import Foundation
import SwiftData

@MainActor
final class HabitService {
    static let shared = HabitService()
    
    private init() {}
    
    /// Log progress towards a habit (e.g. +1 cup of water, +15 mins of workout)
    func logProgress(for habit: Habit, amount: Double = 1.0, in context: ModelContext) {
        let calendar = Calendar.current
        let isSameDay = calendar.isDate(habit.lastUpdatedDate, inSameDayAs: Date())
        
        // Reset counter if it's a new day
        if !isSameDay {
            habit.currentValue = 0.0
        }
        
        habit.currentValue += amount
        habit.lastUpdatedDate = Date()
        
        // Update streak if target is met
        if habit.currentValue >= habit.targetValue && habit.streakDays == 0 {
            habit.streakDays = 1
        }
        
        try? context.save()
    }
    
    /// Decrement progress if user over-logged
    func decrementProgress(for habit: Habit, amount: Double = 1.0, in context: ModelContext) {
        habit.currentValue = max(habit.currentValue - amount, 0.0)
        habit.lastUpdatedDate = Date()
        try? context.save()
    }
    
    /// Reset daily habit counts if needed (call at start of day)
    func resetDailyHabitsIfNeeded(habits: [Habit], in context: ModelContext) {
        let calendar = Calendar.current
        for habit in habits {
            if !calendar.isDate(habit.lastUpdatedDate, inSameDayAs: Date()) {
                // If yesterday target was met, keep or increment streak; otherwise reset streak
                let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
                if calendar.isDate(habit.lastUpdatedDate, inSameDayAs: yesterday) {
                    if habit.currentValue >= habit.targetValue {
                        habit.streakDays += 1
                    }
                } else {
                    habit.streakDays = 0
                }
                habit.currentValue = 0.0
            }
        }
        try? context.save()
    }
}
