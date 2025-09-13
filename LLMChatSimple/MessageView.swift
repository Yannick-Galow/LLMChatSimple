import SwiftUI

struct MessageView: View {
    let message: Message
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.role == .user {
                Spacer()
                
                // User message with avatar (same style as bot)
                VStack(alignment: .trailing, spacing: 8) {
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .trailing, spacing: 8) {
                            // User name
                            Text("Du")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.accentColor)
                            
                            // Message content
                            Text(message.content)
                                .font(.body)
                                .foregroundColor(.primary)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .trailing)
                            
                            // Timestamp
                            Text(formatTime(message.timestamp))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        // User avatar
                        Circle()
                            .fill(Color.accentColor.opacity(0.1))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.accentColor)
                            )
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: message.id)
                    }
                }
            } else {
                // Assistant message with avatar
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 12) {
                        // Avatar
                        Circle()
                            .fill(Color.accentColor.opacity(0.1))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "brain.head.profile")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.accentColor)
                            )
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: message.id)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            // Assistant name
                            Text("LLM")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.accentColor)
                            
                            // Message content
                            MarkdownText(content: message.content)
                                .font(.body)
                                .foregroundColor(.primary)
                                .textSelection(.enabled)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .leading)
                            
                            // Timestamp
                            Text(formatTime(message.timestamp))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
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
