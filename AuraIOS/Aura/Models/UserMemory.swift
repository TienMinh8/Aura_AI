import Foundation
import SwiftData

@Model
final class UserMemory {
    var id: UUID = UUID()
    var category: String = "general" // preferences, work, family, projects, corrections, general
    var title: String = ""
    var content: String = ""
    var learnedAt: Date = Date()
    var isCorrection: Bool = false
    
    init(
        title: String,
        content: String,
        category: String = "general",
        isCorrection: Bool = false,
        learnedAt: Date = Date()
    ) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.category = category
        self.isCorrection = isCorrection
        self.learnedAt = learnedAt
    }
    
    var categoryIcon: String {
        switch category {
        case "preferences": return "heart.fill"
        case "work": return "briefcase.fill"
        case "family": return "person.2.fill"
        case "projects": return "folder.fill"
        case "corrections": return "arrow.triangle.2.circlepath.circle.fill"
        default: return "brain.head.profile"
        }
    }
    
    var categoryDisplayName: String {
        switch category {
        case "preferences": return "Sở thích"
        case "work": return "Công việc"
        case "family": return "Gia đình"
        case "projects": return "Dự án"
        case "corrections": return "Đã học từ sửa lỗi"
        default: return "Thông tin chung"
        }
    }
    
    static var defaults: [UserMemory] {
        [
            UserMemory(
                title: "Thói quen cà phê sáng",
                content: "Uống cà phê Americano không đường vào lúc 8:30 sáng.",
                category: "preferences"
            ),
            UserMemory(
                title: "Dự án đang triển khai",
                content: "Đang phát triển ứng dụng Aura Memory AI trên iOS với SwiftData & EventKit.",
                category: "projects"
            ),
            UserMemory(
                title: "Giờ làm việc tập trung",
                content: "Ưu tiên làm việc sâu từ 9:00 - 11:30 sáng, không lên lịch họp vào khung giờ này.",
                category: "work"
            ),
            UserMemory(
                title: "Đính chính: Ăn chay thứ 2",
                content: "Người dùng đã đính chính: Chỉ ăn chay vào ngày rằm và mùng 1, không ăn chay mỗi thứ Hai.",
                category: "corrections",
                isCorrection: true
            )
        ]
    }
}
