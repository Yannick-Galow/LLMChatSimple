import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatManager: ChatManager
    @State private var messageText = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient.subtleGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Messages Area
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: DesignSystem.Spacing.md) {
                            // Welcome Message (if no messages)
                            if chatManager.messages.isEmpty {
                                VStack(spacing: DesignSystem.Spacing.lg) {
                                    Image(systemName: "brain.head.profile")
                                        .font(.system(size: 60, weight: .light))
                                        .foregroundColor(DesignSystem.Colors.primary.opacity(0.6))
                                    
                                    Text("Willkommen bei LLM Chat")
                                        .font(DesignSystem.Typography.title2)
                                        .foregroundColor(DesignSystem.Colors.primaryText)
                                    
                                    Text("Stellen Sie Ihre Fragen und erhalten Sie intelligente Antworten")
                                        .font(DesignSystem.Typography.body)
                                        .foregroundColor(DesignSystem.Colors.secondaryText)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, DesignSystem.Spacing.xl)
                                }
                                .padding(.top, DesignSystem.Spacing.xxxl)
                            }
                            
                            // Messages
                            ForEach(chatManager.messages) { message in
                                MessageView(message: message)
                                    .id(message.id)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .bottom).combined(with: .opacity),
                                        removal: .move(edge: .top).combined(with: .opacity)
                                    ))
                            }
                            
                            // Loading Indicator
                            if chatManager.isLoading {
                                LoadingMessageView()
                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.vertical, DesignSystem.Spacing.md)
                    }
                    .onChange(of: chatManager.messages.count) { _ in
                        if let lastMessage = chatManager.messages.last {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Input Area
                VStack(spacing: 0) {
                    Divider()
                        .background(DesignSystem.Colors.tertiaryText.opacity(0.3))
                    
                    HStack(spacing: DesignSystem.Spacing.md) {
                        // Text Input
                        HStack(spacing: DesignSystem.Spacing.sm) {
                            TextField("Nachricht eingeben...", text: $messageText, axis: .vertical)
                                .font(DesignSystem.Typography.body)
                                .focused($isTextFieldFocused)
                                .lineLimit(1...4)
                                .padding(.horizontal, DesignSystem.Spacing.lg)
                                .padding(.vertical, DesignSystem.Spacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                                        .fill(DesignSystem.Colors.secondaryBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                                                .stroke(DesignSystem.Colors.primary.opacity(0.2), lineWidth: 1)
                                        )
                                )
                                .onSubmit {
                                    sendMessage()
                                }
                            
                            // Send Button
                            Button(action: sendMessage) {
                                ZStack {
                                    Circle()
                                        .fill(messageText.isEmpty ? DesignSystem.Colors.tertiaryText.opacity(0.3) : DesignSystem.Colors.primary)
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: "arrow.up")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(messageText.isEmpty ? DesignSystem.Colors.tertiaryText : .white)
                                }
                            }
                            .disabled(messageText.isEmpty || chatManager.isLoading)
                            .scaleEffect(messageText.isEmpty ? 0.9 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: messageText.isEmpty)
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    .padding(.vertical, DesignSystem.Spacing.md)
                    .background(DesignSystem.Colors.background)
                }
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
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            messageText = ""
            isTextFieldFocused = false
        }
        
        Task {
            await chatManager.sendMessage(userMessage)
        }
    }
}

// MARK: - Loading Message View
struct LoadingMessageView: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
            // Loading Avatar
            Circle()
                .fill(DesignSystem.Colors.primary.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.primary)
                )
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                Text("LLM")
                    .font(DesignSystem.Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                HStack(spacing: DesignSystem.Spacing.sm) {
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(DesignSystem.Colors.primary)
                                .frame(width: 6, height: 6)
                                .scaleEffect(animationOffset == index ? 1.2 : 0.8)
                                .animation(
                                    .easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                    value: animationOffset
                                )
                        }
                    }
                    
                    Text("LLM denkt nach...")
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Colors.secondaryText)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.vertical, DesignSystem.Spacing.md)
        .onAppear {
            animationOffset = 0
        }
    }
}
