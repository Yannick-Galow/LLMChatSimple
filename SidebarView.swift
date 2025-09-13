import SwiftUI

struct SidebarView: View {
    @ObservedObject var chatManager: ChatManager
    @State private var showingNewConversation = false
    @State private var showingSettings = false
    @State private var llmHost: String = "192.168.0.234:1010"
    @State private var selectedProtocol: String = "http"
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var conversationToDelete: Conversation?
    @State private var showingDeleteAlert = false
    let onConversationSelected: () -> Void
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient.subtleGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: DesignSystem.Spacing.md) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("LLM Chat")
                                .font(DesignSystem.Typography.title2)
                                .fontWeight(.bold)
                                .foregroundColor(DesignSystem.Colors.primaryText)
                            
                            Text("Intelligente Gespräche")
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showingSettings.toggle()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(DesignSystem.Colors.primary.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "gear")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(DesignSystem.Colors.primary)
                                    .rotationEffect(.degrees(showingSettings ? 180 : 0))
                                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showingSettings)
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    .padding(.top, DesignSystem.Spacing.lg)
                }
                .background(DesignSystem.Colors.background)
                .shadow(color: DesignSystem.Shadows.small.color, radius: DesignSystem.Shadows.small.radius, x: 0, y: 2)
                
                Divider()
                    .background(DesignSystem.Colors.tertiaryText.opacity(0.3))
            
                // Conversations List
                if chatManager.conversations.isEmpty {
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(DesignSystem.Colors.primary.opacity(0.4))
                        
                        VStack(spacing: DesignSystem.Spacing.sm) {
                            Text("Keine Unterhaltungen")
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.primaryText)
                            
                            Text("Tippen Sie auf das + Symbol, um eine neue Unterhaltung zu beginnen")
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, DesignSystem.Spacing.lg)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, DesignSystem.Spacing.xxxl)
                } else {
                    ScrollView {
                        LazyVStack(spacing: DesignSystem.Spacing.sm) {
                            ForEach(chatManager.conversations) { conversation in
                                ConversationRowView(
                                    conversation: conversation,
                                    isSelected: chatManager.currentConversation?.id == conversation.id,
                                    onTap: {
                                        chatManager.selectConversation(conversation)
                                        onConversationSelected()
                                    },
                                    onDelete: {
                                        conversationToDelete = conversation
                                        showingDeleteAlert = true
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.vertical, DesignSystem.Spacing.md)
                    }
                }
            
            Spacer()
            
                // Settings Section
                if showingSettings {
                    VStack(spacing: 0) {
                        Divider()
                            .background(DesignSystem.Colors.tertiaryText.opacity(0.3))
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                                // Settings Header
                                HStack {
                                    Image(systemName: "gear")
                                        .font(.title2)
                                        .foregroundColor(DesignSystem.Colors.primary)
                                    
                                    Text("Einstellungen")
                                        .font(DesignSystem.Typography.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(DesignSystem.Colors.primaryText)
                                    
                                    Spacer()
                                }
                                .padding(.bottom, DesignSystem.Spacing.sm)
                                
                                // LLM Server Konfiguration
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                                    Text("LLM Server")
                                        .font(DesignSystem.Typography.headline)
                                        .foregroundColor(DesignSystem.Colors.primaryText)
                                    
                                    // Protokoll-Auswahl
                                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                                        Text("Protokoll")
                                            .font(DesignSystem.Typography.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(DesignSystem.Colors.primaryText)
                                        
                                        Picker("Protokoll", selection: $selectedProtocol) {
                                            Text("HTTP").tag("http")
                                            Text("HTTPS").tag("https")
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                                    }
                                    .cardStyle()
                                    .padding(.horizontal, DesignSystem.Spacing.sm)
                                    
                                    // Host-Eingabe
                                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                                        Text("Host (IP oder Domain)")
                                            .font(DesignSystem.Typography.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(DesignSystem.Colors.primaryText)
                                        
                                        TextField("z.B. 192.168.1.100:8080 oder example.ngrok.io:443", text: $llmHost)
                                            .font(DesignSystem.Typography.body)
                                            .padding(.horizontal, DesignSystem.Spacing.md)
                                            .padding(.vertical, DesignSystem.Spacing.sm)
                                            .background(
                                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                                                    .fill(DesignSystem.Colors.secondaryBackground)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                                                            .stroke(DesignSystem.Colors.primary.opacity(0.2), lineWidth: 1)
                                                    )
                                            )
                                            .autocapitalization(.none)
                                            .disableAutocorrection(true)
                                        
                                        // Beispiel-URLs
                                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                            Text("Beispiele:")
                                                .font(DesignSystem.Typography.caption)
                                                .foregroundColor(DesignSystem.Colors.secondaryText)
                                            
                                            Text("• 192.168.1.100:8080 (lokale IP)")
                                                .font(DesignSystem.Typography.caption)
                                                .foregroundColor(DesignSystem.Colors.secondaryText)
                                            
                                            Text("• 28e91d456350.ngrok-free.app:80 (ngrok)")
                                                .font(DesignSystem.Typography.caption)
                                                .foregroundColor(DesignSystem.Colors.secondaryText)
                                            
                                            Text("• api.example.com:443 (Domain)")
                                                .font(DesignSystem.Typography.caption)
                                                .foregroundColor(DesignSystem.Colors.secondaryText)
                                        }
                                        .padding(.top, DesignSystem.Spacing.xs)
                                    }
                                    .cardStyle()
                                    .padding(.horizontal, DesignSystem.Spacing.sm)
                                    
                                    // Debug-Information
                                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                        Text("Aktuelle URL:")
                                            .font(DesignSystem.Typography.caption)
                                            .foregroundColor(DesignSystem.Colors.secondaryText)
                                        
                                        Text(chatManager.getServerURL())
                                            .font(DesignSystem.Typography.caption)
                                            .foregroundColor(DesignSystem.Colors.primary)
                                            .padding(DesignSystem.Spacing.sm)
                                            .background(
                                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                                                    .fill(DesignSystem.Colors.primary.opacity(0.1))
                                            )
                                    }
                                    .cardStyle()
                                    .padding(.horizontal, DesignSystem.Spacing.sm)
                                    
                                    Button(action: saveSettings) {
                                        Text("Speichern")
                                            .primaryButtonStyle()
                                    }
                                    .padding(.horizontal, DesignSystem.Spacing.sm)
                                }
                            }
                            .padding(DesignSystem.Spacing.lg)
                        }
                    }
                    .background(DesignSystem.Colors.background)
                    .transition(.move(edge: .bottom))
                }
        }
        .background(Color(.systemBackground))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showingSettings)
        .onAppear {
            loadSettings()
        }
        .alert("Einstellungen", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .alert("Chat löschen", isPresented: $showingDeleteAlert) {
            Button("Abbrechen", role: .cancel) {
                conversationToDelete = nil
            }
            Button("Löschen", role: .destructive) {
                if let conversation = conversationToDelete {
                    chatManager.deleteConversation(conversation)
                }
                conversationToDelete = nil
            }
        } message: {
            if let conversation = conversationToDelete {
                Text("Möchten Sie den Chat '\(conversation.title)' wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.")
            }
        }
    }
    
    private func saveSettings() {
        if isValidIP(llmHost) {
            UserDefaults.standard.set(llmHost, forKey: "llm_server_ip")
            UserDefaults.standard.set(selectedProtocol, forKey: "llm_server_protocol")
            chatManager.updateServerURL(llmHost)
            chatManager.updateServerProtocol(selectedProtocol)
            alertMessage = "Einstellungen gespeichert!\n\nNeue URL: \(selectedProtocol)://\(llmHost)/v1/chat/completions"
            showingAlert = true
        } else {
            alertMessage = "Bitte geben Sie eine gültige Host-Adresse ein:\n\n• IP-Adresse: 192.168.1.100:8080\n• Domain: example.ngrok.io:80\n• ngrok: 28e91d456350.ngrok-free.app:80"
            showingAlert = true
        }
    }
    
    private func loadSettings() {
        llmHost = UserDefaults.standard.string(forKey: "llm_server_ip") ?? "192.168.0.234:1010"
        selectedProtocol = UserDefaults.standard.string(forKey: "llm_server_protocol") ?? "http"
    }
    
    private func isValidIP(_ ip: String) -> Bool {
        // Unterstützt sowohl IP-Adressen als auch Domains
        let components = ip.components(separatedBy: ":")
        guard components.count == 2,
              let port = Int(components[1]),
              port > 0 && port < 65536 else {
            return false
        }
        
        let host = components[0]
        
        // Prüfe ob es eine IP-Adresse ist
        if isIPAddress(host) {
            return true
        }
        
        // Prüfe ob es eine gültige Domain ist
        if isValidDomain(host) {
            return true
        }
        
        return false
    }
    
    private func isIPAddress(_ host: String) -> Bool {
        let ipComponents = host.components(separatedBy: ".")
        guard ipComponents.count == 4 else { return false }
        
        for component in ipComponents {
            guard let num = Int(component), num >= 0 && num <= 255 else {
                return false
            }
        }
        
        return true
    }
    
    private func isValidDomain(_ host: String) -> Bool {
        // Einfache Domain-Validierung
        let domainRegex = "^[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?(\\.([a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?))*$"
        let domainPredicate = NSPredicate(format: "SELF MATCHES %@", domainRegex)
        return domainPredicate.evaluate(with: host)
    }
}

struct ConversationRowView: View {
    let conversation: Conversation
    let isSelected: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    
    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: conversation.lastMessageAt, relativeTo: Date())
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DesignSystem.Spacing.md) {
                // Conversation Icon
                ZStack {
                    Circle()
                        .fill(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.primary.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSelected ? .white : DesignSystem.Colors.primary)
                }
                
                // Conversation Content
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    HStack {
                        Text(conversation.title)
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(DesignSystem.Colors.primaryText)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(timeAgo)
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                    }
                    
                    if let lastMessage = conversation.messages.last {
                        Text(lastMessage.content)
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                            .lineLimit(2)
                    }
                    
                    HStack {
                        Text("\(conversation.messages.count) Nachrichten")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.tertiaryText)
                        
                        Spacer()
                        
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                    }
                }
            }
            .padding(.vertical, DesignSystem.Spacing.md)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .fill(isSelected ? DesignSystem.Colors.primary.opacity(0.1) : DesignSystem.Colors.secondaryBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                            .stroke(isSelected ? DesignSystem.Colors.primary : Color.clear, lineWidth: 1)
                    )
            )
            .shadow(
                color: isSelected ? DesignSystem.Shadows.medium.color : DesignSystem.Shadows.small.color,
                radius: isSelected ? DesignSystem.Shadows.medium.radius : DesignSystem.Shadows.small.radius,
                x: 0,
                y: isSelected ? DesignSystem.Shadows.medium.y : DesignSystem.Shadows.small.y
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(action: onDelete) {
                Label("Löschen", systemImage: "trash")
            }
            .tint(DesignSystem.Colors.error)
        }
    }
}
