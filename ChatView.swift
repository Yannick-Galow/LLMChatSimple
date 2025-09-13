import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatManager: ChatManager
    @State private var messageText = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // Clean Background
            DesignSystem.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Messages Area
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: DesignSystem.Spacing.lg) {
                            // Welcome Message (if no messages)
                            if chatManager.messages.isEmpty {
                                VStack(spacing: DesignSystem.Spacing.xl) {
                                    // Clean Icon
                                    ZStack {
                                        Circle()
                                            .fill(DesignSystem.Colors.primary.opacity(0.1))
                                            .frame(width: 80, height: 80)
                                        
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 32, weight: .light))
                                            .foregroundColor(DesignSystem.Colors.primary)
                                    }
                                    
                                    VStack(spacing: DesignSystem.Spacing.sm) {
                                        Text("Willkommen")
                                            .font(DesignSystem.Typography.title2)
                                            .foregroundColor(DesignSystem.Colors.primaryText)
                                        
                                        Text("Stellen Sie Ihre Fragen und erhalten Sie intelligente Antworten")
                                            .font(DesignSystem.Typography.body)
                                            .foregroundColor(DesignSystem.Colors.secondaryText)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, DesignSystem.Spacing.xxxl)
                                    }
                                }
                                .padding(.top, DesignSystem.Spacing.xxxxl)
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
                        .padding(.horizontal, DesignSystem.Spacing.xl)
                        .padding(.vertical, DesignSystem.Spacing.lg)
                    }
                    .onChange(of: chatManager.messages.count) { _ in
                        if let lastMessage = chatManager.messages.last {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Clean Input Area
                VStack(spacing: 0) {
                    // Subtle Divider
                    Rectangle()
                        .fill(DesignSystem.Colors.borderLight)
                        .frame(height: 1)
                    
                    HStack(spacing: DesignSystem.Spacing.md) {
                        // Text Input
                        HStack(spacing: DesignSystem.Spacing.sm) {
                            TextField("Nachricht eingeben...", text: $messageText, axis: .vertical)
                                .font(DesignSystem.Typography.body)
                                .focused($isTextFieldFocused)
                                .lineLimit(1...4)
                                .cleanInputStyle()
                                .onSubmit {
                                    sendMessage()
                                }
                            
                            // Clean Send Button
                            Button(action: sendMessage) {
                                ZStack {
                                    Circle()
                                        .fill(messageText.isEmpty ? DesignSystem.Colors.border : DesignSystem.Colors.primary)
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "arrow.up")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(messageText.isEmpty ? DesignSystem.Colors.tertiaryText : .white)
                                }
                            }
                            .disabled(messageText.isEmpty || chatManager.isLoading)
                            .scaleEffect(messageText.isEmpty ? 0.95 : 1.0)
                            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: messageText.isEmpty)
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.xl)
                    .padding(.vertical, DesignSystem.Spacing.lg)
                    .background(DesignSystem.Colors.secondaryBackground)
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

// MARK: - Clean Loading Message View
struct LoadingMessageView: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
            // Clean Loading Avatar
            Circle()
                .fill(DesignSystem.Colors.primary.opacity(0.1))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(DesignSystem.Colors.primary)
                )
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                Text("AI")
                    .font(DesignSystem.Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                HStack(spacing: DesignSystem.Spacing.sm) {
                    // Clean Loading Dots
                    HStack(spacing: 3) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(DesignSystem.Colors.primary.opacity(0.6))
                                .frame(width: 4, height: 4)
                                .scaleEffect(animationOffset == index ? 1.3 : 0.7)
                                .animation(
                                    .easeInOut(duration: 0.8)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.3),
                                    value: animationOffset
                                )
                        }
                    }
                    
                    Text("Denkt nach...")
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Colors.secondaryText)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, DesignSystem.Spacing.xl)
        .padding(.vertical, DesignSystem.Spacing.md)
        .onAppear {
            animationOffset = 0
        }
    }
}
