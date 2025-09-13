import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatManager: ChatManager
    @State private var messageText = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(chatManager.messages) { message in
                            MessageView(message: message)
                                .id(message.id)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)
                                ))
                        }
                        
                        if chatManager.isLoading {
                            HStack(alignment: .top, spacing: 12) {
                                // Loading avatar
                                Circle()
                                    .fill(Color.accentColor.opacity(0.1))
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Image(systemName: "brain.head.profile")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.accentColor)
                                    )
                                    .scaleEffect(1.0)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).repeatForever(autoreverses: true), value: chatManager.isLoading)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("LLM")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.accentColor)
                                    
                                    HStack(spacing: 8) {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                                        Text("LLM denkt nach...")
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
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
            
            // Input Area
            HStack(spacing: 12) {
                TextField("Nachricht eingeben...", text: $messageText, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isTextFieldFocused)
                    .lineLimit(1...4)
                    .onSubmit {
                        sendMessage()
                    }
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(messageText.isEmpty ? .gray : .blue)
                        .scaleEffect(messageText.isEmpty ? 0.9 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: messageText.isEmpty)
                }
                .disabled(messageText.isEmpty || chatManager.isLoading)
            }
            .padding()
            .background(Color(.systemBackground))
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
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            messageText = ""
            isTextFieldFocused = false
        }
        
        Task {
            await chatManager.sendMessage(userMessage)
        }
    }
}
