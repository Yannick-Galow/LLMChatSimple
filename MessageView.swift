import SwiftUI

struct MessageView: View {
    let message: Message
    @Environment(\.colorScheme) var colorScheme
    @State private var showingCopyConfirmation = false
    
    private var isUser: Bool {
        message.role == .user
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
            if isUser {
                Spacer()
                
                // Clean User Message
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.sm) {
                    // Message Bubble
                    VStack(alignment: .trailing, spacing: DesignSystem.Spacing.sm) {
                        // Message Content
                        Text(message.content)
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.userMessageText)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .trailing)
                            .multilineTextAlignment(.trailing)
                        
                        // Clean Copy Button and Timestamp
                        HStack(spacing: DesignSystem.Spacing.sm) {
                            Button(action: copyMessage) {
                                HStack(spacing: 3) {
                                    Image(systemName: showingCopyConfirmation ? "checkmark" : "doc.on.doc")
                                        .font(.caption2)
                                    Text(showingCopyConfirmation ? "Kopiert!" : "Kopieren")
                                        .font(.caption2)
                                }
                                .foregroundColor(DesignSystem.Colors.userMessageText.opacity(0.7))
                                .padding(.horizontal, DesignSystem.Spacing.sm)
                                .padding(.vertical, DesignSystem.Spacing.xs)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                                        .fill(DesignSystem.Colors.userMessageText.opacity(0.1))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text(formatTime(message.timestamp))
                                .font(DesignSystem.Typography.caption2)
                                .foregroundColor(DesignSystem.Colors.userMessageText.opacity(0.6))
                        }
                    }
                    .messageBubbleStyle(isUser: true)
                    .shadow(color: DesignSystem.Shadows.small.color, radius: DesignSystem.Shadows.small.radius, x: DesignSystem.Shadows.small.x, y: DesignSystem.Shadows.small.y)
                    
                    // Clean User Avatar
                    Circle()
                        .fill(DesignSystem.Colors.primary)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                        )
                }
            } else {
                // Clean Assistant Message
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    // Clean Assistant Avatar
                    Circle()
                        .fill(DesignSystem.Colors.primary.opacity(0.1))
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "sparkles")
                                .font(.system(size: 12, weight: .light))
                                .foregroundColor(DesignSystem.Colors.primary)
                        )
                    
                    // Message Bubble
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        // Message Content
                        MarkdownText(content: message.content)
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.assistantMessageText)
                            .textSelection(.enabled)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .leading)
                        
                        // Clean Copy Button and Timestamp
                        HStack(spacing: DesignSystem.Spacing.sm) {
                            Button(action: copyMessage) {
                                HStack(spacing: 3) {
                                    Image(systemName: showingCopyConfirmation ? "checkmark" : "doc.on.doc")
                                        .font(.caption2)
                                    Text(showingCopyConfirmation ? "Kopiert!" : "Kopieren")
                                        .font(.caption2)
                                }
                                .foregroundColor(DesignSystem.Colors.primary)
                                .padding(.horizontal, DesignSystem.Spacing.sm)
                                .padding(.vertical, DesignSystem.Spacing.xs)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                                        .fill(DesignSystem.Colors.primary.opacity(0.08))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            Text(formatTime(message.timestamp))
                                .font(DesignSystem.Typography.caption2)
                                .foregroundColor(DesignSystem.Colors.tertiaryText)
                        }
                    }
                    .messageBubbleStyle(isUser: false)
                    .shadow(color: DesignSystem.Shadows.small.color, radius: DesignSystem.Shadows.small.radius, x: DesignSystem.Shadows.small.x, y: DesignSystem.Shadows.small.y)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.xl)
        .padding(.vertical, DesignSystem.Spacing.sm)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func copyMessage() {
        UIPasteboard.general.string = message.content
        
        // Zeige Bestätigung
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showingCopyConfirmation = true
        }
        
        // Verstecke Bestätigung nach 2 Sekunden
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showingCopyConfirmation = false
            }
        }
    }
}

struct MarkdownText: View {
    let content: String
    
    var body: some View {
        Text(processedContent)
    }
    
    private var processedContent: AttributedString {
        // Bereinige den Text vor der Markdown-Verarbeitung
        let cleanedContent = cleanText(content)
        
        // Versuche Markdown zu rendern
        if let attributedString = try? AttributedString(markdown: cleanedContent) {
            return attributedString
        } else {
            // Fallback: Zeige bereinigten Text ohne Markdown
            return AttributedString(cleanedContent)
        }
    }
    
    private func cleanText(_ text: String) -> String {
        var cleaned = text
        
        // Entferne oder ersetze problematische Zeichen
        cleaned = cleaned
            // Entferne doppelte Doppelpunkte
            .replacingOccurrences(of: "::", with: ":")
            // Ersetze seltsame Anführungszeichen
            .replacingOccurrences(of: "\u{201C}", with: "\"")  // Left double quotation mark
            .replacingOccurrences(of: "\u{201D}", with: "\"")  // Right double quotation mark
            .replacingOccurrences(of: "\u{2018}", with: "'")   // Left single quotation mark
            .replacingOccurrences(of: "\u{2019}", with: "'")   // Right single quotation mark
            // Ersetze Em-Dash und En-Dash
            .replacingOccurrences(of: "\u{2014}", with: "—")   // Em dash
            .replacingOccurrences(of: "\u{2013}", with: "-")   // En dash
            // Entferne überflüssige Leerzeichen
            .replacingOccurrences(of: "  ", with: " ")
            .replacingOccurrences(of: "\n\n\n", with: "\n\n")
            // Bereinige Markdown-Listen
            .replacingOccurrences(of: "\n- ", with: "\n• ")
            .replacingOccurrences(of: "\n* ", with: "\n• ")
            // Bereinige Code-Blöcke
            .replacingOccurrences(of: "```\n", with: "```\n")
            .replacingOccurrences(of: "\n```", with: "\n```")
        
        return cleaned
    }
}
