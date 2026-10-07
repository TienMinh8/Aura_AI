import SwiftUI

struct LiveActivitiesSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var enableLiveActivities: Bool = true
    @State private var selectedCategoryIcon: String = "timer"
    
    let categoryIcons = [
        "timer", "bell.fill", "sun.max.fill", "moon.stars.fill",
        "drop.fill", "flame.fill", "heart.fill", "bolt.fill",
        "star.fill", "leaf.fill", "cup.and.saucer.fill", "airplane",
        "figure.walk", "figure.run", "book.fill", "briefcase.fill",
        "cross.fill", "flag.fill"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Dynamic Island Preview Hero
                    VStack(spacing: 12) {
                        Text("DYNAMIC ISLAND PREVIEW")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color.auraTextMuted)
                            .tracking(1)
                        
                        // Expanded Dynamic Island Island Capsule
                        HStack(spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: selectedCategoryIcon)
                                    .foregroundStyle(Color.auraAmber)
                                    .font(.system(size: 14, weight: .bold))
                                
                                Text("Event countdown")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            
                            Spacer()
                            
                            Text("14m remaining")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.auraAmber)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(Color.black)
                                .overlay(Capsule().stroke(Color.white.opacity(0.18), lineWidth: 0.8))
                        )
                        .shadow(color: Color.black.opacity(0.6), radius: 16, y: 8)
                        .padding(.horizontal, 12)
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.auraCard)
                            .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.auraBorder, lineWidth: 0.8))
                    )
                    
                    // Switch Toggle
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Live Activities & Island")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                            
                            Text("Keep reminders actively counting down in Island")
                                .font(.system(size: 13))
                                .foregroundStyle(Color.auraTextSecondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $enableLiveActivities)
                            .labelsHidden()
                            .tint(Color.auraAmber)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.auraCard)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.auraBorder, lineWidth: 0.8))
                    )
                    
                    // Category Icons Grid
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Active Icon Style (18 Variations)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                            ForEach(categoryIcons, id: \.self) { icon in
                                let isSelected = selectedCategoryIcon == icon
                                
                                Button {
                                    AuraHaptic.selection()
                                    selectedCategoryIcon = icon
                                } label: {
                                    Image(systemName: icon)
                                        .font(.system(size: 18))
                                        .foregroundStyle(isSelected ? Color.auraAmber : .white)
                                        .frame(width: 46, height: 46)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(isSelected ? Color.auraAmberSoft : Color.white.opacity(0.06))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 14)
                                                        .stroke(isSelected ? Color.auraAmber : Color.clear, lineWidth: 1.5)
                                                )
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(Color.auraBackground.ignoresSafeArea())
            .navigationTitle("Live Activities")
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
