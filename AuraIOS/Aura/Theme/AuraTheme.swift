import SwiftUI

// MARK: - Color Palette
extension Color {
    /// OLED Pure Dark Background
    static let auraBackground = Color(red: 0.035, green: 0.035, blue: 0.043) // #09090B
    /// Card / Surface Background
    static let auraCard = Color(red: 0.11, green: 0.11, blue: 0.118) // #1C1C1E
    /// Hover / Highlight Card
    static let auraCardHover = Color(red: 0.15, green: 0.15, blue: 0.165) // #26262A
    /// Floating Bar Background
    static let auraBarBg = Color(red: 0.118, green: 0.118, blue: 0.133) // #1E1E22
    /// Tab Active Pill Background
    static let auraTabActive = Color(red: 0.22, green: 0.22, blue: 0.24) // #38383D
    /// Primary Amber Orange
    static let auraAmber = Color(red: 1.0, green: 0.584, blue: 0.0) // #FF9500
    /// Amber Glow / Soft Background
    static let auraAmberSoft = Color(red: 1.0, green: 0.584, blue: 0.0).opacity(0.18)
    /// Subtle Border
    static let auraBorder = Color.white.opacity(0.12)
    /// Secondary Text
    static let auraTextSecondary = Color(red: 0.63, green: 0.63, blue: 0.67) // #A1A1AA
    /// Muted Text
    static let auraTextMuted = Color(red: 0.44, green: 0.44, blue: 0.48) // #71717A
    /// Emerald Success Green
    static let auraSuccess = Color(red: 0.2, green: 0.78, blue: 0.35) // #34D399
    /// Soft Red Error / Alert
    static let auraError = Color(red: 0.95, green: 0.3, blue: 0.3)
    /// Cyan Info / Reset
    static let auraInfo = Color(red: 0.0, green: 0.898, blue: 1.0)
}

// MARK: - Typography & Fonts
struct AuraFonts {
    static func titleSerif(size: CGFloat = 34) -> Font {
        .custom("InstrumentSerif-Regular", size: size, relativeTo: .largeTitle)
    }
    
    static func display(size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
    
    static func rounded(size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

// MARK: - Haptic Feedback Helper
struct AuraHaptic {
    static func selection() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}
