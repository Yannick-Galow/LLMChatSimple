import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatManager: ChatManager
    @State private var messageText = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages Area
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Welcome Message
                        if chatManager.messages.isEmpty {
                            WelcomeView()
                        }
                        
                        // Messages
                        ForEach(chatManager.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        
                        // Loading Indicator
                        if chatManager.isLoading {
                            LoadingView()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
                .onChange(of: chatManager.messages.count) { _ in
                    if let lastMessage = chatManager.messages.last {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            // Modern Input Area
            VStack(spacing: 0) {
                Divider()
                    .background(Color.gray.opacity(0.2))
                
                HStack(alignment: .bottom, spacing: 12) {
                    // Text Input Container
                    HStack(spacing: 8) {
                        TextField("Nachricht eingeben...", text: $messageText, axis: .vertical)
                            .focused($isTextFieldFocused)
                            .lineLimit(1...6)
                            .font(.body)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color(.systemGray6))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(isTextFieldFocused ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                            )
                            .onSubmit {
                                if !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    sendMessage()
                                }
                            }
                        
                        // Send Button
                        Button(action: sendMessage) {
                            ZStack {
                                Circle()
                                    .fill(messageText.isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                                    .frame(width: 44, height: 44)
                                    .scaleEffect(messageText.isEmpty ? 0.9 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: messageText.isEmpty)
                                
                                Image(systemName: messageText.isEmpty ? "plus" : "arrow.up")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(messageText.isEmpty ? .gray : .white)
                                    .rotationEffect(.degrees(messageText.isEmpty ? 45 : 0))
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: messageText.isEmpty)
                            }
                        }
                        .disabled(messageText.isEmpty || chatManager.isLoading)
                        .scaleEffect(messageText.isEmpty ? 0.95 : 1.0)
                        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: messageText.isEmpty)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(
                    Color(.systemBackground)
                        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: -1)
                )
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isTextFieldFocused = true
        }
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Prüfe auf /clear Befehl
        if userMessage == "/clear" {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                chatManager.clearCurrentChat()
            }
            messageText = ""
            isTextFieldFocused = false
            return
        }
        
        // Prüfe auf /new Befehl
        if userMessage == "/new" {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                chatManager.createNewConversation()
            }
            messageText = ""
            isTextFieldFocused = false
            return
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            messageText = ""
            isTextFieldFocused = false
        }
        
        Task {
            await chatManager.sendMessage(userMessage)
        }
    }
}

// MARK: - Welcome View
struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 50))
                .foregroundColor(.blue)
            
            Text("Willkommen bei LLM Chat")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Dein lokaler LLM Client")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 50)
    }
}

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.role == .user {
                Spacer(minLength: 60)
            }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 6) {
                // Message Content
                Text(message.content)
                    .font(.body)
                    .foregroundColor(message.role == .user ? .white : .primary)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(message.role == .user ? 
                                  LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                  ) : 
                                  LinearGradient(
                                    gradient: Gradient(colors: [Color(.systemGray6), Color(.systemGray5)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                  )
                            )
                            .shadow(
                                color: message.role == .user ? 
                                Color.blue.opacity(0.3) : 
                                Color.black.opacity(0.1), 
                                radius: 4, 
                                x: 0, 
                                y: 2
                            )
                    )
                    .scaleEffect(1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: message.content)
                
                // Timestamp
                Text(formatTime(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
            }
            
            if message.role != .user {
                Spacer(minLength: 60)
            }
        }
        .padding(.horizontal, 4)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.accentColor.opacity(0.1))
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.accentColor)
                )
                .scaleEffect(1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).repeatForever(autoreverses: true), value: true)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("AI")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    Text("Denkt nach...")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}