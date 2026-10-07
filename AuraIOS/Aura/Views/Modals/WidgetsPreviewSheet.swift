import SwiftUI

struct WidgetsPreviewSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSize: Int = 0 // 0: Small, 1: Medium, 2: Large
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Segmented Control Size Picker
                Picker("Size", selection: $selectedSize) {
                    Text("Small").tag(0)
                    Text("Medium").tag(1)
                    Text("Large").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                Spacer()
                
                // Widget Container Preview
                Group {
                    switch selectedSize {
                    case 0:
                        smallWidgetPreview
                    case 1:
                        mediumWidgetPreview
                    case 2:
                        largeWidgetPreview
                    default:
                        smallWidgetPreview
                    }
                }
                .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
                
                Spacer()
                
                // Instructions Info
                VStack(spacing: 6) {
                    Text("How to add widgets")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Touch and hold an empty area on your Home Screen, tap the (+) button in the upper left corner, and search for Aura.")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.auraTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 16)
            }
            .background(Color.auraBackground.ignoresSafeArea())
            .navigationTitle("Home Screen Widgets")
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
    
    // MARK: - Small Widget (158 x 158)
    private var smallWidgetPreview: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("OCT 6")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.auraAmber)
                Spacer()
                Image(systemName: "sparkles")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.auraAmber)
            }
            
            Text("6")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Next routine")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.auraTextMuted)
                Text("Weather brief")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
        .padding(16)
        .frame(width: 158, height: 158)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.14))
                .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(Color.auraBorder, lineWidth: 0.8))
        )
    }
    
    // MARK: - Medium Widget (338 x 158)
    private var mediumWidgetPreview: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("TODAY'S TIMELINE")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.auraAmber)
                Spacer()
                Text("Oct 2026")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.auraTextSecondary)
            }
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    taskRowMini("08:00", "Morning brief", "sun.max.fill")
                    taskRowMini("09:00", "AI News update", "newspaper.fill")
                    taskRowMini("16:00", "Weather check", "cloud.rain.fill")
                }
            }
        }
        .padding(16)
        .frame(width: 328, height: 158)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.14))
                .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(Color.auraBorder, lineWidth: 0.8))
        )
    }
    
    private func taskRowMini(_ time: String, _ title: String, _ icon: String) -> some View {
        HStack(spacing: 8) {
            Text(time)
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundStyle(Color.auraTextMuted)
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(Color.auraAmber)
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white)
        }
    }
    
    // MARK: - Large Widget (338 x 338)
    private var largeWidgetPreview: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("AURA OVERVIEW")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.auraAmber)
                Spacer()
                Text("Tue, Oct 6")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            // Mini weekly bar
            HStack(spacing: 8) {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { d in
                    Text(d)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(d == "T" ? .black : Color.auraTextMuted)
                        .frame(maxWidth: .infinity)
                        .frame(height: 24)
                        .background(d == "T" ? Circle().fill(Color.auraAmber) : nil)
                }
            }
            
            Divider().background(Color.white.opacity(0.08))
            
            VStack(alignment: .leading, spacing: 10) {
                Text("UPCOMING REMINDERS")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color.auraTextMuted)
                
                taskRowMini("08:00", "Morning brief & motivation", "sun.max.fill")
                taskRowMini("09:00", "Bitcoin price & 24h change", "chart.line.uptrend.xyaxis")
                taskRowMini("12:30", "Lunch reminder & hydration", "drop.fill")
                taskRowMini("16:00", "New event from chat", "calendar.badge.clock")
            }
            
            Spacer()
        }
        .padding(18)
        .frame(width: 328, height: 328)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.14))
                .overlay(RoundedRectangle(cornerRadius: 28, style: .continuous).stroke(Color.auraBorder, lineWidth: 0.8))
        )
    }
}
