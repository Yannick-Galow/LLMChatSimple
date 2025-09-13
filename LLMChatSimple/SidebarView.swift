import SwiftUI

struct SidebarView: View {
    @ObservedObject var chatManager: ChatManager
    @State private var showingNewConversation = false
    @State private var showingSettings = false
    @State private var llmIP: String = "192.168.0.234:1010"
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var conversationToDelete: Conversation?
    @State private var showingDeleteAlert = false
    let onConversationSelected: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("LLM-Chat")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showingSettings.toggle()
                    }
                }) {
                    Image(systemName: "gear")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(showingSettings ? 180 : 0))
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showingSettings)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            
            Divider()
            
            if chatManager.conversations.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("Keine Unterhaltungen")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Tippen Sie auf das + Symbol, um eine neue Unterhaltung zu beginnen")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(chatManager.conversations) { conversation in
                            ConversationRowView(
                                conversation: conversation,
                                isSelected: chatManager.currentConversation?.id == conversation.id,
                                onTap: {
                                    chatManager.selectConversation(conversation)
                                    onConversationSelected()
                                },
                                onLongPress: {
                                    conversationToDelete = conversation
                                    showingDeleteAlert = true
                                }
                            )
                        }
                    }
                }
            }
            
            Spacer()
            
            // Settings Section
            if showingSettings {
                Divider()
                    .transition(.opacity.combined(with: .move(edge: .top)))
                
                VStack(alignment: .leading, spacing: 16) {
                    // Settings Header
                    HStack {
                        Image(systemName: "gear")
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        Text("Einstellungen")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    
                    // LLM Server Konfiguration
                    VStack(alignment: .leading, spacing: 12) {
                        Text("LLM Server")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("IP:Port", text: $llmIP)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        Button(action: saveSettings) {
                            Text("Speichern")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
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
        if isValidIP(llmIP) {
            UserDefaults.standard.set(llmIP, forKey: "llm_server_ip")
            alertMessage = "Einstellungen gespeichert!"
            showingAlert = true
        } else {
            alertMessage = "Bitte geben Sie eine gültige IP-Adresse ein (z.B. 192.168.1.100:8080)"
            showingAlert = true
        }
    }
    
    private func loadSettings() {
        llmIP = UserDefaults.standard.string(forKey: "llm_server_ip") ?? "192.168.0.234:1010"
    }
    
    private func isValidIP(_ ip: String) -> Bool {
        let components = ip.components(separatedBy: ":")
        guard components.count == 2,
              let port = Int(components[1]),
              port > 0 && port < 65536 else {
            return false
        }
        
        let ipComponents = components[0].components(separatedBy: ".")
        guard ipComponents.count == 4 else { return false }
        
        for component in ipComponents {
            guard let num = Int(component), num >= 0 && num <= 255 else {
                return false
            }
        }
        
        return true
    }
}

struct ConversationRowView: View {
    let conversation: Conversation
    let isSelected: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    
    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: conversation.lastMessageAt, relativeTo: Date())
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(timeAgo)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let lastMessage = conversation.messages.last {
                    Text(lastMessage.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Text("\(conversation.messages.count) Nachrichten")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                onLongPress()
            }
        }
    }
}
