import Foundation
import SwiftData

@Model
final class GoalStep {
    var id: UUID = UUID()
    var stepIndex: Int = 1
    var title: String = ""
    var detailDescription: String = ""
    var isCompleted: Bool = false
    var estimatedTime: String = "15m"
    
    init(
        stepIndex: Int,
        title: String,
        detailDescription: String = "",
        isCompleted: Bool = false,
        estimatedTime: String = "15m"
    ) {
        self.id = UUID()
        self.stepIndex = stepIndex
        self.title = title
        self.detailDescription = detailDescription
        self.isCompleted = isCompleted
        self.estimatedTime = estimatedTime
    }
}

@Model
final class GoalPlan {
    var id: UUID = UUID()
    var title: String = ""
    var goalDescription: String = ""
    var category: String = "general"
    var createdAt: Date = Date()
    var targetCompletionDate: Date?
    @Relationship(deleteRule: .cascade) var steps: [GoalStep] = []
    
    init(
        title: String,
        goalDescription: String = "",
        category: String = "general",
        targetCompletionDate: Date? = nil,
        steps: [GoalStep] = []
    ) {
        self.id = UUID()
        self.title = title
        self.goalDescription = goalDescription
        self.category = category
        self.createdAt = Date()
        self.targetCompletionDate = targetCompletionDate
        self.steps = steps
    }
    
    var progressRatio: Double {
        guard !steps.isEmpty else { return 0 }
        let completedCount = steps.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(steps.count)
    }
    
    var completedStepCount: Int {
        steps.filter { $0.isCompleted }.count
    }
    
    var isAllCompleted: Bool {
        !steps.isEmpty && steps.allSatisfy { $0.isCompleted }
    }
    
    static var defaults: [GoalPlan] {
        let launchSteps = [
            GoalStep(stepIndex: 1, title: "Nghiên cứu đối thủ", detailDescription: "Tìm kiếm và phân tích 3 ứng dụng tương tự trên App Store", isCompleted: true, estimatedTime: "45m"),
            GoalStep(stepIndex: 2, title: "Soạn bản mô tả tính năng", detailDescription: "Hỏi và tổng hợp các yêu cầu người dùng mục tiêu", isCompleted: true, estimatedTime: "30m"),
            GoalStep(stepIndex: 3, title: "Lập trình & Test Simulator", detailDescription: "Build native SwiftUI & SwiftData với zero warnings", isCompleted: false, estimatedTime: "2h"),
            GoalStep(stepIndex: 4, title: "Chuẩn bị bản phát hành TestFlight", detailDescription: "Tạo screenshots, icon và gửi bản thử nghiệm", isCompleted: false, estimatedTime: "1h")
        ]
        
        let fitnessSteps = [
            GoalStep(stepIndex: 1, title: "Khởi động làm nóng", detailDescription: "Xoay khớp và kéo giãn 5 phút", isCompleted: true, estimatedTime: "5m"),
            GoalStep(stepIndex: 2, title: "Cardio 20 phút", detailDescription: "Chạy bộ biến tốc nhẹ nhàng", isCompleted: false, estimatedTime: "20m"),
            GoalStep(stepIndex: 3, title: "Uống 500ml nước bù khoáng", detailDescription: "Nghỉ ngơi và hạ nhiệt cơ thể", isCompleted: false, estimatedTime: "10m")
        ]
        
        return [
            GoalPlan(
                title: "Phát hành phiên bản Aura iOS Beta",
                goalDescription: "Quy trình 4 bước chuẩn bị ra mắt ứng dụng trên TestFlight",
                category: "Dự án",
                steps: launchSteps
            ),
            GoalPlan(
                title: "Buổi rèn luyện thể lực tối nay",
                goalDescription: "Mục tiêu duy trì thể chất hàng ngày",
                category: "Sức khỏe",
                steps: fitnessSteps
            )
        ]
    }
}
