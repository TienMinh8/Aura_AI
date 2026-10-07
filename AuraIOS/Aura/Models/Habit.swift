import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID = UUID()
    var title: String = ""
    var categoryRaw: String = "water" // water, workout, medicine, measurement, custom
    var targetValue: Double = 8.0
    var currentValue: Double = 0.0
    var unit: String = "ly"
    var streakDays: Int = 0
    var reminderHour: Int?
    var reminderMinute: Int?
    var lastUpdatedDate: Date = Date()
    var createdAt: Date = Date()
    var notes: String = ""
    
    init(
        title: String,
        category: String = "water",
        targetValue: Double,
        currentValue: Double = 0.0,
        unit: String,
        streakDays: Int = 0,
        reminderHour: Int? = nil,
        reminderMinute: Int? = nil,
        notes: String = ""
    ) {
        self.id = UUID()
        self.title = title
        self.categoryRaw = category
        self.targetValue = targetValue
        self.currentValue = currentValue
        self.unit = unit
        self.streakDays = streakDays
        self.reminderHour = reminderHour
        self.reminderMinute = reminderMinute
        self.lastUpdatedDate = Date()
        self.createdAt = Date()
        self.notes = notes
    }
    
    var progressRatio: Double {
        guard targetValue > 0 else { return 0 }
        return min(max(currentValue / targetValue, 0.0), 1.0)
    }
    
    var isGoalAchieved: Bool {
        return currentValue >= targetValue
    }
    
    var categoryIcon: String {
        switch categoryRaw {
        case "water": return "drop.fill"
        case "workout": return "figure.run"
        case "medicine": return "pills.fill"
        case "measurement": return "heart.text.square.fill"
        default: return "sparkles"
        }
    }
    
    static var defaults: [Habit] {
        [
            Habit(
                title: "Uống nước",
                category: "water",
                targetValue: 8.0,
                currentValue: 4.0,
                unit: "ly",
                streakDays: 5,
                reminderHour: 9,
                reminderMinute: 0,
                notes: "Mục tiêu 2 lít mỗi ngày"
            ),
            Habit(
                title: "Tập thể dục",
                category: "workout",
                targetValue: 30.0,
                currentValue: 20.0,
                unit: "phút",
                streakDays: 3,
                reminderHour: 17,
                reminderMinute: 30,
                notes: "Chạy bộ hoặc cardio nhẹ"
            ),
            Habit(
                title: "Uống Vitamin & Thuốc",
                category: "medicine",
                targetValue: 1.0,
                currentValue: 1.0,
                unit: "lần",
                streakDays: 12,
                reminderHour: 8,
                reminderMinute: 0,
                notes: "Uống sau bữa ăn sáng"
            ),
            Habit(
                title: "Đo huyết áp & Cân nặng",
                category: "measurement",
                targetValue: 1.0,
                currentValue: 0.0,
                unit: "lần",
                streakDays: 2,
                reminderHour: 21,
                reminderMinute: 0,
                notes: "Theo dõi chỉ số sức khỏe"
            )
        ]
    }
}
