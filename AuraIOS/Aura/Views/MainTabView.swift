import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Base
            Color.auraBackground.ignoresSafeArea()
            
            // Content Screens
            Group {
                switch selectedTab {
                case 0:
                    ChatView()
                case 1:
                    TodayView(onNavigateTab: { tab in
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.72)) {
                            selectedTab = tab
                        }
                    })
                case 2:
                    TasksView(onNavigateTab: { tab in
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.72)) {
                            selectedTab = tab
                        }
                    })
                case 3:
                    ProfileView()
                default:
                    ChatView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Floating Glassmorphism Capsule Bar
            floatingTabBar
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Floating Capsule Bar
    private var floatingTabBar: some View {
        HStack(spacing: 0) {
            tabItem(
                index: 0,
                title: "Chat",
                systemIcon: "message.fill"
            )
            tabItem(
                index: 1,
                title: "Today",
                systemIcon: "calendar"
            )
            tabItem(
                index: 2,
                title: "Tasks",
                systemIcon: "checklist"
            )
            tabItem(
                index: 3,
                title: "Profile",
                systemIcon: "person.crop.circle.fill"
            )
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 6)
        .frame(height: 70)
        .background(
            ZStack {
                // Glassmorphism Liquid Blur
                RoundedRectangle(cornerRadius: 38, style: .continuous)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 38, style: .continuous)
                    .fill(Color.auraBarBg.opacity(0.85))
                
                RoundedRectangle(cornerRadius: 38, style: .continuous)
                    .stroke(Color.auraBorder, lineWidth: 0.8)
            }
        )
        .shadow(color: Color.black.opacity(0.45), radius: 20, x: 0, y: 10)
    }
    
    // MARK: - Single Tab Button Item
    private func tabItem(index: Int, title: String, systemIcon: String) -> some View {
        let isSelected = selectedTab == index
        
        return Button {
            if selectedTab != index {
                AuraHaptic.selection()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
                    selectedTab = index
                }
            }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: systemIcon)
                    .font(.system(size: 20, weight: isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? Color.auraAmber : Color.white)
                
                Text(title)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .medium))
                    .foregroundStyle(isSelected ? Color.auraAmber : Color.auraTextSecondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(Color.auraTabActive)
                            .matchedGeometryEffect(id: "ActiveTabIndicator", in: tabNamespace)
                    } else {
                        Color.clear
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
    
    @Namespace private var tabNamespace
}

#Preview {
    MainTabView()
}
