import SwiftUI

struct UsageSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPackage: Int = 20
    
    let packages: [(price: Int, tokens: String, bonus: String?)] = [
        (5, "50,000", nil),
        (20, "250,000", "POPULAR"),
        (50, "750,000", "+15% BONUS"),
        (500, "10,000,000", "ENTERPRISE")
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Balance Hero Card
                VStack(spacing: 8) {
                    Text("CURRENT BALANCE")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.auraTextMuted)
                        .tracking(1)
                    
                    Text("$9.93")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text("Tokens are consumed when Nova reads documents, generates schedules, and handles smart queries.")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.auraTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.auraCard)
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.auraBorder, lineWidth: 0.8))
                )
                
                // Packages Grid
                VStack(alignment: .leading, spacing: 12) {
                    Text("Top up balance")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(packages, id: \.price) { pkg in
                            let isSelected = selectedPackage == pkg.price
                            
                            Button {
                                AuraHaptic.selection()
                                selectedPackage = pkg.price
                            } label: {
                                VStack(spacing: 6) {
                                    if let bonus = pkg.bonus {
                                        Text(bonus)
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundStyle(isSelected ? .black : Color.auraAmber)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(
                                                Capsule()
                                                    .fill(isSelected ? Color.white : Color.auraAmber.opacity(0.18))
                                            )
                                    } else {
                                        Spacer().frame(height: 14)
                                    }
                                    
                                    Text("$\(pkg.price)")
                                        .font(.system(size: 26, weight: .bold, design: .rounded))
                                        .foregroundStyle(isSelected ? Color.auraAmber : .white)
                                    
                                    Text("\(pkg.tokens) tokens")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(Color.auraTextSecondary)
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(Color.auraCard)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 18)
                                                .stroke(isSelected ? Color.auraAmber : Color.auraBorder, lineWidth: isSelected ? 1.5 : 0.8)
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                Spacer()
                
                // Apple Pay CTA
                Button {
                    AuraHaptic.medium()
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 18))
                        Text("Top up $\(selectedPackage) with Apple Pay")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(Color.auraAmber))
                    .shadow(color: Color.auraAmber.opacity(0.35), radius: 10, y: 4)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 8)
            }
            .padding(16)
            .background(Color.auraBackground.ignoresSafeArea())
            .navigationTitle("Token Usage")
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
