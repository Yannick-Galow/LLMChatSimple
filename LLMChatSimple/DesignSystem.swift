import SwiftUI

// MARK: - Modern Design System
struct DesignSystem {
    
    // MARK: - Colors - Modern & Sophisticated
    struct Colors {
        // Primary Colors - Modern Purple/Blue Gradient
        static let primary = Color(red: 0.4, green: 0.2, blue: 0.8) // Deep Purple
        static let primaryLight = Color(red: 0.6, green: 0.4, blue: 0.9) // Light Purple
        static let primaryDark = Color(red: 0.3, green: 0.1, blue: 0.7) // Dark Purple
        static let primaryGradient = LinearGradient(
            colors: [Color(red: 0.4, green: 0.2, blue: 0.8), Color(red: 0.6, green: 0.3, blue: 0.9)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Background Colors - Modern Dark/Light Theme
        static let background = Color(red: 0.98, green: 0.98, blue: 0.99) // Soft White
        static let secondaryBackground = Color.white
        static let tertiaryBackground = Color(red: 0.96, green: 0.97, blue: 0.98) // Cool Gray
        static let cardBackground = Color.white
        static let surfaceBackground = Color(red: 0.99, green: 0.99, blue: 1.0) // Almost White
        
        // Text Colors - High Contrast & Readable
        static let primaryText = Color(red: 0.05, green: 0.05, blue: 0.1) // Near Black
        static let secondaryText = Color(red: 0.3, green: 0.3, blue: 0.4) // Dark Gray
        static let tertiaryText = Color(red: 0.5, green: 0.5, blue: 0.6) // Medium Gray
        static let quaternaryText = Color(red: 0.7, green: 0.7, blue: 0.8) // Light Gray
        
        // Accent Colors - Vibrant & Modern
        static let success = Color(red: 0.0, green: 0.7, blue: 0.4) // Modern Green
        static let warning = Color(red: 1.0, green: 0.6, blue: 0.0) // Vibrant Orange
        static let error = Color(red: 0.9, green: 0.2, blue: 0.3) // Modern Red
        static let info = Color(red: 0.0, green: 0.6, blue: 0.9) // Modern Blue
        
        // Message Colors - Modern & Clean
        static let userMessage = Color(red: 0.4, green: 0.2, blue: 0.8) // Primary Purple
        static let assistantMessage = Color(red: 0.97, green: 0.98, blue: 1.0) // Very Light Blue
        static let userMessageText = Color.white
        static let assistantMessageText = Color(red: 0.1, green: 0.1, blue: 0.15)
        
        // Border Colors - Subtle & Modern
        static let border = Color(red: 0.88, green: 0.89, blue: 0.92) // Light Gray
        static let borderLight = Color(red: 0.94, green: 0.95, blue: 0.97) // Very Light Gray
        static let borderAccent = Color(red: 0.4, green: 0.2, blue: 0.8).opacity(0.2) // Purple Border
        
        // Shadow Colors - Modern & Layered
        static let shadow = Color.black.opacity(0.03) // Very Light
        static let shadowMedium = Color.black.opacity(0.08) // Light
        static let shadowStrong = Color.black.opacity(0.12) // Medium
        static let shadowAccent = Color(red: 0.4, green: 0.2, blue: 0.8).opacity(0.15) // Purple Shadow
        
        // Glass Effect Colors
        static let glassBackground = Color.white.opacity(0.8)
        static let glassBorder = Color.white.opacity(0.2)
    }
    
    // MARK: - Typography - Modern & Hierarchical
    struct Typography {
        // Display Styles
        static let largeTitle = Font.system(size: 36, weight: .bold, design: .rounded)
        static let title = Font.system(size: 30, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 24, weight: .semibold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
        
        // Body Styles
        static let headline = Font.system(size: 18, weight: .semibold, design: .default)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let bodyBold = Font.system(size: 16, weight: .semibold, design: .default)
        static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
        static let callout = Font.system(size: 16, weight: .medium, design: .default)
        static let subheadline = Font.system(size: 15, weight: .medium, design: .default)
        
        // Small Styles
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .medium, design: .default)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
        
        // Special Styles
        static let button = Font.system(size: 16, weight: .semibold, design: .default)
        static let messageText = Font.system(size: 16, weight: .regular, design: .default)
        static let messageTime = Font.system(size: 12, weight: .medium, design: .default)
    }
    
    // MARK: - Spacing - Modern 8pt Grid
    struct Spacing {
        static let xs: CGFloat = 4    // 0.25rem
        static let sm: CGFloat = 8    // 0.5rem
        static let md: CGFloat = 12   // 0.75rem
        static let lg: CGFloat = 16   // 1rem
        static let xl: CGFloat = 20   // 1.25rem
        static let xxl: CGFloat = 24  // 1.5rem
        static let xxxl: CGFloat = 32 // 2rem
        static let xxxxl: CGFloat = 40 // 2.5rem
        static let xxxxxl: CGFloat = 48 // 3rem
        static let xxxxxxl: CGFloat = 64 // 4rem
    }
    
    // MARK: - Corner Radius - Modern & Consistent
    struct CornerRadius {
        static let xs: CGFloat = 4     // Small elements
        static let small: CGFloat = 8  // Buttons, small cards
        static let medium: CGFloat = 12 // Cards, inputs
        static let large: CGFloat = 16  // Large cards
        static let xl: CGFloat = 20     // Extra large cards
        static let xxl: CGFloat = 24    // Hero elements
        static let round: CGFloat = 50  // Circular elements
        static let pill: CGFloat = 100  // Pill-shaped elements
    }
    
    // MARK: - Shadows - Modern & Layered
    struct Shadows {
        static let none = Shadow(color: .clear, radius: 0, x: 0, y: 0)
        static let xs = Shadow(color: Colors.shadow, radius: 1, x: 0, y: 1)
        static let small = Shadow(color: Colors.shadow, radius: 2, x: 0, y: 1)
        static let medium = Shadow(color: Colors.shadowMedium, radius: 4, x: 0, y: 2)
        static let large = Shadow(color: Colors.shadowStrong, radius: 8, x: 0, y: 4)
        static let xl = Shadow(color: Colors.shadowStrong, radius: 12, x: 0, y: 6)
        static let accent = Shadow(color: Colors.shadowAccent, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Shadow Helper
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions - Modern & Sophisticated
extension View {
    // MARK: - Card Styles
    func modernCardStyle() -> some View {
        self
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(DesignSystem.CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .stroke(DesignSystem.Colors.borderLight, lineWidth: 1)
            )
            .shadow(
                color: DesignSystem.Shadows.medium.color,
                radius: DesignSystem.Shadows.medium.radius,
                x: DesignSystem.Shadows.medium.x,
                y: DesignSystem.Shadows.medium.y
            )
    }
    
    func glassCardStyle() -> some View {
        self
            .background(DesignSystem.Colors.glassBackground)
            .cornerRadius(DesignSystem.CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .stroke(DesignSystem.Colors.glassBorder, lineWidth: 1)
            )
            .shadow(
                color: DesignSystem.Shadows.large.color,
                radius: DesignSystem.Shadows.large.radius,
                x: DesignSystem.Shadows.large.x,
                y: DesignSystem.Shadows.large.y
            )
    }
    
    func messageCardStyle(isUser: Bool) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .fill(isUser ? DesignSystem.Colors.userMessage : DesignSystem.Colors.assistantMessage)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .stroke(
                        isUser ? Color.clear : DesignSystem.Colors.borderLight,
                        lineWidth: 1
                    )
            )
            .shadow(
                color: isUser ? DesignSystem.Shadows.accent.color : DesignSystem.Shadows.small.color,
                radius: isUser ? DesignSystem.Shadows.accent.radius : DesignSystem.Shadows.small.radius,
                x: 0,
                y: isUser ? 2 : 1
            )
    }
    
    // MARK: - Button Styles
    func modernPrimaryButtonStyle() -> some View {
        self
            .font(DesignSystem.Typography.button)
            .foregroundColor(.white)
            .padding(.horizontal, DesignSystem.Spacing.xl)
            .padding(.vertical, DesignSystem.Spacing.lg)
            .background(DesignSystem.Colors.primaryGradient)
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .shadow(
                color: DesignSystem.Shadows.accent.color,
                radius: DesignSystem.Shadows.accent.radius,
                x: 0,
                y: 4
            )
    }
    
    func modernSecondaryButtonStyle() -> some View {
        self
            .font(DesignSystem.Typography.button)
            .foregroundColor(DesignSystem.Colors.primary)
            .padding(.horizontal, DesignSystem.Spacing.xl)
            .padding(.vertical, DesignSystem.Spacing.lg)
            .background(DesignSystem.Colors.primary.opacity(0.1))
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(DesignSystem.Colors.primary.opacity(0.3), lineWidth: 1)
            )
    }
    
    func modernFloatingButtonStyle() -> some View {
        self
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 56, height: 56)
            .background(DesignSystem.Colors.primaryGradient)
            .cornerRadius(DesignSystem.CornerRadius.round)
            .shadow(
                color: DesignSystem.Shadows.accent.color,
                radius: DesignSystem.Shadows.accent.radius,
                x: 0,
                y: 6
            )
    }
    
    func modernIconButtonStyle() -> some View {
        self
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(DesignSystem.Colors.primary)
            .frame(width: 44, height: 44)
            .background(DesignSystem.Colors.primary.opacity(0.1))
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(DesignSystem.Colors.primary.opacity(0.2), lineWidth: 1)
            )
    }
    
    // MARK: - Input Styles
    func modernInputStyle() -> some View {
        self
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.lg)
            .background(DesignSystem.Colors.surfaceBackground)
            .cornerRadius(DesignSystem.CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
            )
            .shadow(
                color: DesignSystem.Shadows.small.color,
                radius: DesignSystem.Shadows.small.radius,
                x: 0,
                y: 1
            )
    }
    
    func modernFocusedInputStyle() -> some View {
        self
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.lg)
            .background(DesignSystem.Colors.surfaceBackground)
            .cornerRadius(DesignSystem.CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .stroke(DesignSystem.Colors.primary, lineWidth: 2)
            )
            .shadow(
                color: DesignSystem.Shadows.accent.color,
                radius: DesignSystem.Shadows.accent.radius,
                x: 0,
                y: 4
            )
    }
    
    // MARK: - Message Styles
    func modernMessageStyle(isUser: Bool) -> some View {
        self
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .fill(isUser ? DesignSystem.Colors.userMessage : DesignSystem.Colors.assistantMessage)
            )
            .foregroundColor(isUser ? DesignSystem.Colors.userMessageText : DesignSystem.Colors.assistantMessageText)
            .shadow(
                color: isUser ? DesignSystem.Shadows.accent.color : DesignSystem.Shadows.small.color,
                radius: isUser ? 4 : 2,
                x: 0,
                y: isUser ? 2 : 1
            )
    }
    
    // MARK: - Animation Helpers
    func modernScaleAnimation() -> some View {
        self
            .scaleEffect(1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: UUID())
    }
    
    func modernFadeAnimation() -> some View {
        self
            .opacity(1.0)
            .animation(.easeInOut(duration: 0.2), value: UUID())
    }
    
    // MARK: - Layout Helpers
    func modernPadding() -> some View {
        self
            .padding(.horizontal, DesignSystem.Spacing.xl)
            .padding(.vertical, DesignSystem.Spacing.lg)
    }
    
    func modernCardPadding() -> some View {
        self
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.lg)
    }
}

// MARK: - Custom Gradients - Modern & Sophisticated
extension LinearGradient {
    static let modernBackground = LinearGradient(
        colors: [DesignSystem.Colors.background, DesignSystem.Colors.tertiaryBackground],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let modernPrimary = LinearGradient(
        colors: [DesignSystem.Colors.primary, DesignSystem.Colors.primaryLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let modernAccent = LinearGradient(
        colors: [DesignSystem.Colors.primaryLight, DesignSystem.Colors.primary],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let modernGlass = LinearGradient(
        colors: [DesignSystem.Colors.glassBackground, DesignSystem.Colors.glassBackground.opacity(0.6)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
