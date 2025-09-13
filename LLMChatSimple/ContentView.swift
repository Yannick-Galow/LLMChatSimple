import SwiftUI

struct ContentView: View {
    @StateObject private var chatManager = ChatManager()
    @State private var showingSidebar = false
    
    var body: some View {
        ZStack {
            // Main Chat Area
            VStack(spacing: 0) {
                ChatView()
                    .environmentObject(chatManager)
            }
            .overlay(
                // Modern Floating Action Buttons
                VStack {
                    HStack {
                        // Modern Sidebar Toggle Button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showingSidebar.toggle()
                            }
                            // Tastatur ausblenden
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 48, height: 48)
                                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                                
                                Image(systemName: showingSidebar ? "xmark" : "line.3.horizontal")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.8))
                            }
                        }
                        .scaleEffect(showingSidebar ? 1.05 : 1.0)
                        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: showingSidebar)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                },
                alignment: .top
            )
            
            // Modern Sidebar Overlay
            if showingSidebar {
                // Background overlay with blur
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showingSidebar = false
                        }
                        // Tastatur ausblenden
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
                // Modern Sidebar content
                HStack {
                    ModernSidebarView(chatManager: chatManager, onConversationSelected: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showingSidebar = false
                        }
                    })
                        .frame(width: 320)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 5, y: 0)
                        )
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    
                    Spacer()
                }
                .padding(.leading, 16)
            }
        }
    }
}

// MARK: - Modern Sidebar View
struct ModernSidebarView: View {
    @ObservedObject var chatManager: ChatManager
    let onConversationSelected: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Modern Header
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Unterhaltungen")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(red: 0.05, green: 0.05, blue: 0.1))
                        
                        Text("\(chatManager.conversations.count) Gespräche")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.6))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            Divider()
                .background(Color(red: 0.94, green: 0.95, blue: 0.97))
            
            // Modern Conversations List
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(chatManager.conversations) { conversation in
                        ModernConversationCard(
                            conversation: conversation,
                            isSelected: chatManager.currentConversation?.id == conversation.id,
                            onTap: {
                                chatManager.selectConversation(conversation)
                                onConversationSelected()
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            
            Spacer()
            
            // Modern Footer Actions
            VStack(spacing: 12) {
                Divider()
                    .background(Color(red: 0.94, green: 0.95, blue: 0.97))
                
                VStack(spacing: 8) {
                    Button(action: {
                        chatManager.createNewConversation()
                        onConversationSelected()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 16, weight: .medium))
                            Text("Neue Unterhaltung")
                                .font(.system(size: 16, weight: .medium))
                            Spacer()
                        }
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.8))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.4, green: 0.2, blue: 0.8).opacity(0.1))
                        )
                    }
                    
                    Button(action: {
                        chatManager.clearCurrentChat()
                        onConversationSelected()
                    }) {
                        HStack {
                            Image(systemName: "trash.circle.fill")
                                .font(.system(size: 16, weight: .medium))
                            Text("Aktuelle löschen")
                                .font(.system(size: 16, weight: .medium))
                            Spacer()
                        }
                        .foregroundColor(Color(red: 0.9, green: 0.2, blue: 0.3))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.9, green: 0.2, blue: 0.3).opacity(0.1))
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - Modern Conversation Card
struct ModernConversationCard: View {
    let conversation: Conversation
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(conversation.title)
                        .font(.system(size: 16, weight: .medium))
                        .fontWeight(isSelected ? .semibold : .regular)
                        .foregroundColor(isSelected ? Color(red: 0.4, green: 0.2, blue: 0.8) : Color(red: 0.05, green: 0.05, blue: 0.1))
                        .lineLimit(2)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.8))
                    }
                }
                
                HStack {
                    Text(formatDate(conversation.lastMessageAt))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.6))
                    
                    Spacer()
                    
                    Text("\(conversation.messages.count) Nachrichten")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.8))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(red: 0.4, green: 0.2, blue: 0.8).opacity(0.1) : Color(red: 0.99, green: 0.99, blue: 1.0))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color(red: 0.4, green: 0.2, blue: 0.8).opacity(0.3) : Color(red: 0.94, green: 0.95, blue: 0.97),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}