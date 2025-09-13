import SwiftUI

// MARK: - Clean Design System
struct DesignSystem {
    
    // MARK: - Colors - Clean & Minimal
    struct Colors {
        // Primary Colors - Clean Blue
        static let primary = Color(red: 0.0, green: 0.45, blue: 0.95)
        static let primaryLight = Color(red: 0.0, green: 0.55, blue: 1.0)
        static let primaryDark = Color(red: 0.0, green: 0.35, blue: 0.85)
        
        // Background Colors - Pure & Clean
        static let background = Color(red: 0.98, green: 0.98, blue: 0.99) // Almost white
        static let secondaryBackground = Color.white
        static let tertiaryBackground = Color(red: 0.96, green: 0.96, blue: 0.97)
        static let cardBackground = Color.white
        
        // Text Colors - High Contrast
        static let primaryText = Color(red: 0.1, green: 0.1, blue: 0.1)
        static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.4)
        static let tertiaryText = Color(red: 0.6, green: 0.6, blue: 0.6)
        
        // Accent Colors - Subtle
        static let success = Color(red: 0.2, green: 0.7, blue: 0.3)
        static let warning = Color(red: 1.0, green: 0.6, blue: 0.0)
        static let error = Color(red: 0.95, green: 0.2, blue: 0.2)
        static let info = Color(red: 0.0, green: 0.45, blue: 0.95)
        
        // Message Colors - Clean & Minimal
        static let userMessage = Color(red: 0.0, green: 0.45, blue: 0.95)
        static let assistantMessage = Color(red: 0.95, green: 0.95, blue: 0.97)
        static let userMessageText = Color.white
        static let assistantMessageText = Color(red: 0.1, green: 0.1, blue: 0.1)
        
        // Border Colors
        static let border = Color(red: 0.9, green: 0.9, blue: 0.9)
        static let borderLight = Color(red: 0.95, green: 0.95, blue: 0.95)
        
        // Shadow Colors
        static let shadow = Color.black.opacity(0.05)
        static let shadowMedium = Color.black.opacity(0.1)
        static let shadowStrong = Color.black.opacity(0.15)
    }
    
    // MARK: - Typography - Clean & Readable
    struct Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
        static let title = Font.system(size: 28, weight: .bold, design: .default)
        static let title2 = Font.system(size: 22, weight: .semibold, design: .default)
        static let title3 = Font.system(size: 20, weight: .medium, design: .default)
        static let headline = Font.system(size: 17, weight: .semibold, design: .default)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let bodyBold = Font.system(size: 16, weight: .semibold, design: .default)
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
    }
    
    // MARK: - Spacing - Clean Grid
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
        static let xxxxl: CGFloat = 40
    }
    
    // MARK: - Corner Radius - Clean & Consistent
    struct CornerRadius {
        static let small: CGFloat = 6
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20
        static let round: CGFloat = 50
    }
    
    // MARK: - Shadows - Subtle & Clean
    struct Shadows {
        static let small = Shadow(color: Colors.shadow, radius: 2, x: 0, y: 1)
        static let medium = Shadow(color: Colors.shadowMedium, radius: 4, x: 0, y: 2)
        static let large = Shadow(color: Colors.shadowStrong, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Shadow Helper
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions - Clean & Minimal
extension View {
    func cardStyle() -> some View {
        self
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(DesignSystem.Colors.borderLight, lineWidth: 1)
            )
            .shadow(color: DesignSystem.Shadows.small.color, radius: DesignSystem.Shadows.small.radius, x: DesignSystem.Shadows.small.x, y: DesignSystem.Shadows.small.y)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .font(DesignSystem.Typography.headline)
            .foregroundColor(.white)
            .padding(.horizontal, DesignSystem.Spacing.xl)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.primary)
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .shadow(color: DesignSystem.Shadows.small.color, radius: DesignSystem.Shadows.small.radius, x: DesignSystem.Shadows.small.x, y: DesignSystem.Shadows.small.y)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(DesignSystem.Typography.headline)
            .foregroundColor(DesignSystem.Colors.primary)
            .padding(.horizontal, DesignSystem.Spacing.xl)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.primary.opacity(0.08))
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(DesignSystem.Colors.primary.opacity(0.2), lineWidth: 1)
            )
    }
    
    func messageBubbleStyle(isUser: Bool) -> some View {
        self
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .fill(isUser ? DesignSystem.Colors.userMessage : DesignSystem.Colors.assistantMessage)
            )
            .foregroundColor(isUser ? DesignSystem.Colors.userMessageText : DesignSystem.Colors.assistantMessageText)
    }
    
    func cleanInputStyle() -> some View {
        self
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .fill(DesignSystem.Colors.secondaryBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                            .stroke(DesignSystem.Colors.border, lineWidth: 1)
                    )
            )
    }
    
    func cleanButtonStyle() -> some View {
        self
            .font(DesignSystem.Typography.body)
            .foregroundColor(DesignSystem.Colors.primary)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                    .fill(DesignSystem.Colors.primary.opacity(0.08))
            )
    }
}

// MARK: - Custom Gradients - Clean & Subtle
extension LinearGradient {
    static let cleanGradient = LinearGradient(
        colors: [DesignSystem.Colors.background, DesignSystem.Colors.tertiaryBackground],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let primaryGradient = LinearGradient(
        colors: [DesignSystem.Colors.primary, DesignSystem.Colors.primaryDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
