import SwiftUI
import SwiftData

struct AnalyticsReportSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var habits: [Habit]
    @Query private var events: [AuraEvent]
    @Query private var goalPlans: [GoalPlan]
    
    let weeklyDays = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
    let thisWeekValues: [Double] = [0.75, 0.9, 0.85, 1.0, 0.95, 0.8, 0.9]
    let lastWeekValues: [Double] = [0.6, 0.7, 0.65, 0.8, 0.75, 0.7, 0.65]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.auraBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Summary Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("HIỆU SUẤT TUẦN NÀY")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(Color.auraTextMuted)
                                    .tracking(1.2)
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "arrow.up.right")
                                    Text("+14.2% vs tuần trước")
                                }
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Color.auraSuccess)
                            }
                            
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text("89%")
                                    .font(.system(size: 38, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                
                                Text("tỷ lệ hoàn thành mục tiêu")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.auraTextSecondary)
                            }
                            
                            // Weekly comparison bar chart
                            VStack(spacing: 12) {
                                HStack(alignment: .bottom, spacing: 14) {
                                    ForEach(0..<7, id: \.self) { index in
                                        VStack(spacing: 6) {
                                            ZStack(alignment: .bottom) {
                                                // Background bar (Last week)
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color.white.opacity(0.08))
                                                    .frame(width: 22, height: 120 * lastWeekValues[index])
                                                
                                                // Foreground bar (This week)
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color.auraAmber)
                                                    .frame(width: 22, height: 120 * thisWeekValues[index])
                                            }
                                            
                                            Text(weeklyDays[index])
                                                .font(.system(size: 11, weight: .semibold))
                                                .foregroundStyle(Color.auraTextMuted)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                                .frame(height: 150)
                                .padding(.top, 10)
                                
                                HStack(spacing: 20) {
                                    HStack(spacing: 6) {
                                        Circle().fill(Color.auraAmber).frame(width: 8, height: 8)
                                        Text("Tuần này").font(.system(size: 11)).foregroundStyle(.white)
                                    }
                                    HStack(spacing: 6) {
                                        Circle().fill(Color.white.opacity(0.15)).frame(width: 8, height: 8)
                                        Text("Tuần trước").font(.system(size: 11)).foregroundStyle(Color.auraTextMuted)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding(.top, 8)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.auraCard)
                                .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.auraBorder, lineWidth: 0.8))
                        )
                        .padding(.horizontal, 16)
                        
                        // Habit breakdown metrics
                        VStack(alignment: .leading, spacing: 14) {
                            Text("CHI TIẾT THÓI QUEN")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(Color.auraTextMuted)
                                .tracking(1.2)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 12) {
                                ForEach(habits) { habit in
                                    HStack(spacing: 14) {
                                        Image(systemName: habit.categoryIcon)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundStyle(Color.auraAmber)
                                            .frame(width: 36, height: 36)
                                            .background(Circle().fill(Color.auraAmberSoft))
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(habit.title)
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundStyle(.white)
                                            
                                            Text("Đạt \(Int(habit.currentValue))/\(Int(habit.targetValue)) \(habit.unit) · Chuỗi \(habit.streakDays) ngày")
                                                .font(.system(size: 12))
                                                .foregroundStyle(Color.auraTextSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("\(Int(habit.progressRatio * 100))%")
                                            .font(.system(size: 14, weight: .bold, design: .rounded))
                                            .foregroundStyle(habit.isGoalAchieved ? Color.auraSuccess : Color.auraAmber)
                                    }
                                    .padding(14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.auraCard)
                                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.auraBorder, lineWidth: 0.8))
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Nova's Executive Summary
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                    .foregroundStyle(Color.auraAmber)
                                Text("Nhận xét từ Nova AI")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            
                            Text("Bạn đang có sự tiến bộ vượt bậc ở thói quen uống nước và rèn luyện thể lực. Khung giờ tập trung hiệu quả nhất của bạn rơi vào 9:00 - 11:00 sáng. Hãy tiếp tục duy trì nhịp điệu sinh hoạt này trong tuần tới!")
                                .font(.system(size: 13))
                                .foregroundStyle(Color.auraTextSecondary)
                                .lineSpacing(4)
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white.opacity(0.04))
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.auraAmber.opacity(0.3), lineWidth: 0.8))
                        )
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Báo cáo & Phân tích")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Đóng") {
                        dismiss()
                    }
                    .foregroundStyle(Color.auraAmber)
                }
            }
        }
    }
}
