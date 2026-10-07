import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var profiles: [UserProfile]
    @State private var selectedTheme: String = "Dark"
    @State private var activeSheet: ActiveSheet? = nil
    
    private var user: UserProfile {
        profiles.first ?? UserProfile()
    }
    
    enum ActiveSheet: String, Identifiable {
        case capabilities
        case calendars
        case connectedApps
        case memoryBank
        case analytics
        case usage
        case widgets
        case liveActivities
        
        var id: String {
            rawValue
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Sun Glow Avatar & Name
                sunAvatarHero
                    .padding(.top, 24)
                
                // Spaces Card
                spacesSection
                
                // Assistant Settings List
                assistantSection
                
                // Appearance Selector
                appearanceSection
                
                // Sign out
                signOutButton
                
                Spacer(minLength: 120)
            }
            .padding(.horizontal, 16)
        }
        .background(Color.auraBackground.ignoresSafeArea())
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .capabilities:
                CapabilitiesSheet()
            case .calendars:
                CalendarSyncSheet()
            case .connectedApps:
                ConnectedAppsSheet()
            case .memoryBank:
                MemoryBankSheet()
            case .analytics:
                AnalyticsReportSheet()
            case .usage:
                UsageSheet()
            case .widgets:
                WidgetsPreviewSheet()
            case .liveActivities:
                LiveActivitiesSheet()
            }
        }
    }
    
    // MARK: - Sun Glow Avatar
    private var sunAvatarHero: some View {
        VStack(spacing: 12) {
            ZStack {
                // Radial Glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.auraAmber.opacity(0.35), Color.clear],
                            center: .center,
                            startRadius: 30,
                            endRadius: 80
                        )
                    )
                    .frame(width: 150, height: 150)
                
                // Sun Rays
                ForEach(0..<12) { i in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.auraAmber.opacity(0.4))
                        .frame(width: 6, height: 16)
                        .offset(y: -58)
                        .rotationEffect(.degrees(Double(i) * 30))
                }
                
                // Central Sun Disk
                Circle()
                    .fill(Color(red: 0.95, green: 0.76, blue: 0.42))
                    .frame(width: 88, height: 88)
                    .overlay(
                        Text("M")
                            .font(.system(size: 38, weight: .bold, design: .serif))
                            .foregroundStyle(Color(red: 0.35, green: 0.22, blue: 0.08))
                    )
                
                // Edit Pencil Badge
                Circle()
                    .fill(Color.auraCard)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "pencil")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                    )
                    .offset(x: 32, y: 32)
            }
            
            Text(user.name)
                .font(.system(size: 26, weight: .bold, design: .serif))
                .foregroundStyle(.white)
        }
    }
    
    // MARK: - Spaces Card
    private var spacesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Share events with family or a team")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
            
            Text("Everyone in a space sees its events and gets the reminders.")
                .font(.system(size: 13))
                .foregroundStyle(Color.auraTextSecondary)
            
            HStack(spacing: 12) {
                spaceChip(title: "Family", icon: "house.fill", color: Color.orange)
                spaceChip(title: "Work", icon: "briefcase.fill", color: Color.blue)
                spaceChip(title: "Home", icon: "leaf.fill", color: Color.green)
            }
            .padding(.top, 4)
            
            Divider()
                .background(Color.white.opacity(0.08))
                .padding(.vertical, 4)
            
            Button {} label: {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundStyle(Color.auraTextSecondary)
                    Text("Enter invite code")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.auraTextMuted)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.auraCard)
                .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(Color.auraBorder, lineWidth: 0.8))
        )
    }
    
    private func spaceChip(title: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(color.opacity(0.8)))
                
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .background(Circle().fill(Color.black))
                    .offset(x: 4, y: 4)
            }
            
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.04))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.auraBorder, lineWidth: 0.6))
        )
    }
    
    // MARK: - Assistant Section
    private var assistantSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Assistant")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.auraTextMuted)
                .padding(.leading, 6)
            
            VStack(spacing: 0) {
                settingRow(icon: "sparkles", title: "Capabilities", subtitle: "Morning brief, water, birthdays and more") {
                    activeSheet = .capabilities
                }
                
                dividerLine
                
                settingRow(icon: "brain.head.profile", title: "Bộ nhớ & Bài học AI", subtitle: "Sở thích, dự án, sửa lỗi") {
                    activeSheet = .memoryBank
                }
                
                dividerLine
                
                settingRow(icon: "chart.line.uptrend.xyaxis", title: "Báo cáo & Phân tích", subtitle: "Xu hướng thói quen & so sánh tuần") {
                    activeSheet = .analytics
                }
                
                dividerLine
                
                settingRow(icon: "calendar", title: "Calendars", subtitle: nil) {
                    activeSheet = .calendars
                }
                
                dividerLine
                
                settingRow(icon: "link", title: "Connected apps", subtitle: nil) {
                    activeSheet = .connectedApps
                }
                
                dividerLine
                
                settingRow(icon: "creditcard", title: "Token usage", subtitle: "$9.93 balance") {
                    activeSheet = .usage
                }
                
                dividerLine
                
                settingRow(icon: "square.grid.2x2", title: "Widgets", subtitle: nil) {
                    activeSheet = .widgets
                }
                
                dividerLine
                
                settingRow(icon: "bell.badge", title: "Live Activities", subtitle: nil) {
                    activeSheet = .liveActivities
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.auraCard)
                    .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(Color.auraBorder, lineWidth: 0.8))
            )
        }
    }
    
    private func settingRow(icon: String, title: String, subtitle: String?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.auraTextSecondary)
                    .frame(width: 28)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.auraTextMuted)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.auraTextMuted)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Appearance
    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Appearance")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.auraTextMuted)
                .padding(.leading, 6)
            
            HStack(spacing: 12) {
                themeButton(title: "Auto", icon: "circle.lefthalf.filled")
                themeButton(title: "Dark", icon: "moon.fill")
                themeButton(title: "Light", icon: "sun.max.fill")
            }
        }
    }
    
    private func themeButton(title: String, icon: String) -> some View {
        let isSelected = selectedTheme == title
        return Button {
            AuraHaptic.selection()
            selectedTheme = title
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(isSelected ? Color.auraAmber : Color.auraTextSecondary)
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.auraAmber : .white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.auraCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.auraAmber : Color.auraBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Sign out
    private var signOutButton: some View {
        Button {} label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Sign out")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(Color(red: 1.0, green: 0.27, blue: 0.23))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.auraCard)
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.auraBorder, lineWidth: 0.8))
            )
        }
        .buttonStyle(.plain)
    }
    
    private var dividerLine: some View {
        Divider()
            .background(Color.white.opacity(0.06))
            .padding(.leading, 58)
    }
}
