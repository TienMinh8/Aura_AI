import SwiftUI

struct CapabilitiesSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    struct CapabilityItem: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let subtitle: String
        let details: [String]
        let color: Color
    }
    
    let capabilities: [CapabilityItem] = [
        CapabilityItem(
            icon: "calendar.badge.clock",
            title: "Sự kiện & Nhắc nhở",
            subtitle: "Quản lý lịch trình và deadlines đa chiều",
            details: [
                "Tạo sự kiện một lần hoặc lặp lại (ngày, tuần, tháng, năm)",
                "Đặt nhắc nhở linh hoạt (trước 15p, 30p, 1 giờ, 1 ngày)",
                "Quản lý cuộc họp, lịch làm việc, hẹn gặp và deadline",
                "Hỗ trợ sự kiện cả ngày (sinh nhật, kỳ nghỉ, kỷ niệm)",
                "Chỉnh sửa, dời lịch, xóa và khôi phục sự kiện",
                "Đánh dấu hoàn thành trực tiếp trên thanh thông báo"
            ],
            color: Color.auraAmber
        ),
        CapabilityItem(
            icon: "chart.bar.xaxis",
            title: "Theo dõi Thói quen",
            subtitle: "Giữ vững nhịp sống lành mạnh mỗi ngày",
            details: [
                "Uống nước (mục tiêu X ly mỗi ngày)",
                "Tập thể dục (mục tiêu X phút hoặc X rep)",
                "Nhắc nhở uống thuốc và bổ sung vitamin",
                "Đo lường chỉ số sức khỏe (cân nặng, huyết áp)",
                "Theo dõi bất kỳ thói quen tùy biến nào của bạn",
                "Xem tiến độ chuỗi ngày liên tục (Streaks)"
            ],
            color: Color.cyan
        ),
        CapabilityItem(
            icon: "bubble.left.and.bubble.right.fill",
            title: "Trò chuyện & Tư vấn",
            subtitle: "Người đồng hành thông minh cho mọi khía cạnh",
            details: [
                "Giải đáp câu hỏi chuyên sâu (khoa học, lập trình, tâm lý)",
                "Đưa ra lời khuyên, định hướng và giải pháp",
                "Thảo luận, động não ý tưởng (Brainstorming)",
                "Soạn thảo, hiệu đính và tóm tắt văn bản",
                "Diễn giải các khái niệm phức tạp một cách dễ hiểu"
            ],
            color: Color(red: 0.65, green: 0.55, blue: 0.98)
        ),
        CapabilityItem(
            icon: "brain.head.profile",
            title: "Ghi nhớ & Học hỏi",
            subtitle: "Bộ não thứ hai cá nhân hóa theo bạn",
            details: [
                "Lưu giữ sở thích, thói quen, công việc và dự án",
                "Ghi nhớ ngữ cảnh để câu trả lời luôn khớp với bạn",
                "Học hỏi ngay lập tức khi bạn phản hồi hoặc sửa sai",
                "Dữ liệu được mã hóa và bảo mật trên thiết bị"
            ],
            color: Color.pink
        ),
        CapabilityItem(
            icon: "gearshape.arrow.triangle.2.circlepath",
            title: "Tác vụ tự động",
            subtitle: "Hỗ trợ nền theo giờ hẹn định kỳ",
            details: [
                "Morning Brief tóm tắt lịch trình và tin tức buổi sáng",
                "Tạo thông điệp động lực, bài học và lời khuyên hàng ngày",
                "Chạy API và gửi thông báo theo lịch đặt trước",
                "Tính tổng dữ liệu cá nhân (chi tiêu, thời gian, số bước)"
            ],
            color: Color.orange
        ),
        CapabilityItem(
            icon: "link.circle.fill",
            title: "Kết nối Dịch vụ",
            subtitle: "Đồng bộ đa nền tảng 2 chiều",
            details: [
                "Apple Calendar (iCloud) & Google Calendar",
                "Telegram Bot (nhận voice & note từ xa)",
                "Notion (xuất dữ liệu memory vào database)",
                "Todoist, Slack, và các ứng dụng hàng ngày"
            ],
            color: Color.blue
        ),
        CapabilityItem(
            icon: "chart.line.uptrend.xyaxis",
            title: "Báo cáo & Phân tích",
            subtitle: "Nhìn lại xu hướng và hiệu suất cá nhân",
            details: [
                "Tổng kết chi tiêu và thời gian trong tuần/tháng",
                "Phân tích tần suất thói quen và độ hoàn thành",
                "So sánh hiệu suất giữa tuần này và tuần trước"
            ],
            color: Color.auraSuccess
        ),
        CapabilityItem(
            icon: "arrow.triangle.branch",
            title: "Kế hoạch đa bước",
            subtitle: "Chia nhỏ mục tiêu lớn thành từng bước nhỏ",
            details: [
                "Tự động chia tách mục tiêu: Tìm kiếm ➔ Soạn thảo ➔ Thực thi",
                "Đồng hành nhắc nhở bạn hoàn thành từng chặng",
                "Chuyển đổi ý tưởng lỏng lẻo thành kế hoạch hành động"
            ],
            color: Color(red: 0.95, green: 0.7, blue: 0.2)
        )
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Banner
                    VStack(spacing: 8) {
                        Text("NHỮNG GÌ NOVA CÓ THỂ LÀM")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(Color.auraAmber)
                            .tracking(1.5)
                        
                        Text("Trợ lý Hệ điều hành Cuộc sống")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Nova kết hợp trí tuệ nhân tạo, ghi nhớ ngữ cảnh và tự động hóa để giúp bạn giải phóng tâm trí.")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.auraTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .padding(.top, 12)
                    
                    // List of Capabilities
                    VStack(spacing: 14) {
                        ForEach(capabilities) { item in
                            capabilityCard(item)
                        }
                    }
                    
                    // What Needs Connection Disclaimer Card
                    disclaimerCard
                        .padding(.top, 8)
                }
                .padding(16)
            }
            .background(Color.auraBackground.ignoresSafeArea())
            .navigationTitle("Năng lực của Nova")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Xong") {
                        dismiss()
                    }
                    .foregroundStyle(Color.auraAmber)
                    .font(.system(size: 15, weight: .semibold))
                }
            }
        }
    }
    
    // MARK: - Capability Card
    private func capabilityCard(_ item: CapabilityItem) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: item.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(item.color)
                    .frame(width: 38, height: 38)
                    .background(Circle().fill(item.color.opacity(0.14)))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text(item.subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.auraTextSecondary)
                }
                
                Spacer()
            }
            
            Divider().background(Color.white.opacity(0.06))
            
            VStack(alignment: .leading, spacing: 7) {
                ForEach(item.details, id: \.self) { detail in
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .fill(item.color.opacity(0.8))
                            .frame(width: 5, height: 5)
                            .padding(.top, 6)
                        
                        Text(detail)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.white.opacity(0.85))
                            .lineSpacing(2)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.auraCard)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.auraBorder, lineWidth: 0.8))
        )
    }
    
    // MARK: - Disclaimer Card (Cần kết nối trước)
    private var disclaimerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.auraAmber)
                
                Text("Cần kết nối trước khi sử dụng:")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                bulletPoint("Thời tiết, tin tức, tỷ giá trực tiếp", requirement: "Cần kết nối OpenWeather / CoinGecko API")
                bulletPoint("Tác vụ tìm kiếm web theo lịch", requirement: "Cần kích hoạt Background Task & Search API")
                bulletPoint("Nhận và gửi tin nhắn Telegram", requirement: "Cần cấu hình Bot Token trong Cài đặt")
                bulletPoint("Tự động đăng bài lên X / Twitter", requirement: "Cần liên kết tài khoản X OAuth")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.auraCard)
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.auraAmber.opacity(0.3), lineWidth: 0.8))
        )
    }
    
    private func bulletPoint(_ title: String, requirement: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 6) {
                Text("•")
                    .foregroundStyle(Color.auraAmber)
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white)
            }
            Text("  ➔ \(requirement)")
                .font(.system(size: 11))
                .foregroundStyle(Color.auraTextMuted)
        }
    }
}
