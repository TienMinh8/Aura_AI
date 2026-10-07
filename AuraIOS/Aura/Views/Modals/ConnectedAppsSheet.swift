import SwiftUI

struct ConnectedAppsSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var connections: [String: Bool] = [
        "Telegram": true,
        "Slack": false,
        "Google Calendar": true,
        "Notion": false,
        "X (Twitter)": false,
        "Discord": false
    ]
    
    let apps: [(name: String, desc: String, icon: String, color: Color)] = [
        ("Telegram", "Receive reminders and voice notes in bot", "paperplane.fill", .blue),
        ("Google Calendar", "Bi-directional sync of meetings and events", "calendar.badge.clock", .orange),
        ("Slack", "Sync notifications and team reminders", "number.square.fill", .purple),
        ("Notion", "Export your AI memories into Notion databases", "doc.text.fill", .gray),
        ("X (Twitter)", "Auto-save bookmarked threads to Memory AI", "bubble.left.fill", .cyan),
        ("Discord", "Bot updates in your private server", "gamecontroller.fill", .indigo)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(apps, id: \.name) { app in
                        let isConnected = connections[app.name] ?? false
                        
                        HStack(spacing: 14) {
                            Image(systemName: app.icon)
                                .font(.system(size: 20))
                                .foregroundStyle(app.color)
                                .frame(width: 44, height: 44)
                                .background(Circle().fill(app.color.opacity(0.14)))
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text(app.name)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                                
                                Text(app.desc)
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.auraTextSecondary)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            Button {
                                AuraHaptic.selection()
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                    connections[app.name] = !isConnected
                                }
                            } label: {
                                Text(isConnected ? "Connected" : "Connect")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(isConnected ? Color.auraAmber : .white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(isConnected ? Color.auraAmberSoft : Color.white.opacity(0.1))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.auraCard)
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.auraBorder, lineWidth: 0.8))
                        )
                    }
                }
                .padding(16)
            }
            .background(Color.auraBackground.ignoresSafeArea())
            .navigationTitle("Connected Apps")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(Color.auraAmber)
                    .font(.system(size: 15, weight: .semibold))
                }
            }
        }
    }
}
