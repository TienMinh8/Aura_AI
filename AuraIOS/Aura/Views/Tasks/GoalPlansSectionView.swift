import SwiftUI
import SwiftData

struct GoalPlansSectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \GoalPlan.createdAt, order: .reverse) private var goalPlans: [GoalPlan]
    
    @State private var expandedPlanId: UUID?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(goalPlans) { plan in
                let isExpanded = (expandedPlanId ?? goalPlans.first?.id) == plan.id
                
                VStack(alignment: .leading, spacing: 12) {
                    // Header row
                    HStack(spacing: 12) {
                        Image(systemName: "target")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.auraAmber)
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(Color.auraAmberSoft))
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(plan.title)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                            
                            HStack(spacing: 6) {
                                Text("\(plan.completedStepCount)/\(plan.steps.count) bước")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.auraTextSecondary)
                                
                                Text("·")
                                    .foregroundStyle(Color.auraTextMuted)
                                
                                Text(plan.category)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(Color.auraAmber)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.auraTextMuted)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        AuraHaptic.selection()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            if isExpanded {
                                expandedPlanId = UUID()
                            } else {
                                expandedPlanId = plan.id
                            }
                        }
                    }
                    
                    // Progress Bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 6)
                            
                            Capsule()
                                .fill(plan.isAllCompleted ? Color.auraSuccess : Color.auraAmber)
                                .frame(width: geo.size.width * CGFloat(plan.progressRatio), height: 6)
                        }
                    }
                    .frame(height: 6)
                    
                    // Step List when expanded
                    if isExpanded {
                        VStack(spacing: 10) {
                            ForEach(plan.steps.sorted(by: { $0.stepIndex < $1.stepIndex })) { step in
                                HStack(spacing: 12) {
                                    Button {
                                        AuraHaptic.medium()
                                        step.isCompleted.toggle()
                                        try? modelContext.save()
                                    } label: {
                                        Image(systemName: step.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 20))
                                            .foregroundStyle(step.isCompleted ? Color.auraSuccess : Color.auraTextMuted)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(step.title)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(step.isCompleted ? Color.auraTextMuted : .white)
                                            .strikethrough(step.isCompleted, color: Color.auraTextMuted)
                                        
                                        if !step.detailDescription.isEmpty {
                                            Text(step.detailDescription)
                                                .font(.system(size: 11))
                                                .foregroundStyle(Color.auraTextSecondary)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Text(step.estimatedTime)
                                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                                        .foregroundStyle(Color.auraTextMuted)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.top, 6)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.auraCard)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(plan.isAllCompleted ? Color.auraSuccess.opacity(0.4) : Color.auraBorder, lineWidth: 0.8)
                        )
                )
            }
        }
    }
}
