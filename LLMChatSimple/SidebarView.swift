import SwiftUI

struct SidebarView: View {
    @ObservedObject var chatManager: ChatManager
    let onConversationSelected: () -> Void
    @State private var showingDeleteAlert = false
    @State private var conversationToDelete: Conversation?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 16) {
                Text("Unterhaltungen")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("\(chatManager.conversations.count) Gespräche")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Divider()
                .padding(.vertical, 16)
            
            // Conversations List
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(chatManager.conversations) { conversation in
                        ConversationRow(
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
                .padding(.horizontal, 16)
            }
            
            Spacer()
            
            // Footer Actions
            VStack(spacing: 12) {
                Divider()
                
                Button(action: {
                    chatManager.createNewConversation()
                    onConversationSelected()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Neue Unterhaltung")
                        Spacer()
                    }
                    .foregroundColor(.accentColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Button(action: {
                    if let currentConversation = chatManager.currentConversation {
                        chatManager.deleteConversation(currentConversation)
                        onConversationSelected()
                    }
                }) {
                    HStack {
                        Image(systemName: "trash.circle.fill")
                        Text("Gespräch löschen")
                        Spacer()
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }
                .disabled(chatManager.currentConversation == nil)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .frame(width: 280)
        .background(Color(.systemBackground))
        .alert("Gespräch löschen", isPresented: $showingDeleteAlert) {
            Button("Löschen", role: .destructive) {
                if let conversation = conversationToDelete {
                    chatManager.deleteConversation(conversation)
                }
            }
            Button("Abbrechen", role: .cancel) {
                conversationToDelete = nil
            }
        } message: {
            Text("Möchten Sie dieses Gespräch wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.")
        }
    }
}

struct ConversationRow: View {
    let conversation: Conversation
    let isSelected: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(conversation.title)
                    .font(.callout)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? .accentColor : .primary)
                    .lineLimit(2)
                
                HStack {
                    Text(formatDate(conversation.lastMessageAt))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(conversation.messages.count) Nachrichten")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.5) {
            onLongPress()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}