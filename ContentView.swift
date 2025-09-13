import SwiftUI

struct ContentView: View {
    @StateObject private var chatManager = ChatManager()
    @State private var showingSidebar = false
    
    var body: some View {
        ZStack {
            // Main Chat Area (always full screen)
            VStack(spacing: 0) {
                // Chat View
                ChatView()
                    .environmentObject(chatManager)
            }
            .overlay(
                // Clean Floating Action Buttons
                VStack {
                    HStack {
                        // Clean Sidebar Toggle Button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showingSidebar.toggle()
                            }
                            // Tastatur ausblenden
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            ZStack {
                                Circle()
                                    .fill(DesignSystem.Colors.secondaryBackground)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: DesignSystem.Shadows.medium.color, radius: DesignSystem.Shadows.medium.radius, x: 0, y: DesignSystem.Shadows.medium.y)
                                
                                Image(systemName: showingSidebar ? "xmark" : "line.3.horizontal")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(DesignSystem.Colors.primary)
                            }
                        }
                        .scaleEffect(showingSidebar ? 1.05 : 1.0)
                        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: showingSidebar)
                        
                        Spacer()
                        
                        // Clean New Conversation Button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                chatManager.createNewConversation()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(DesignSystem.Colors.primary)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: DesignSystem.Shadows.medium.color, radius: DesignSystem.Shadows.medium.radius, x: 0, y: DesignSystem.Shadows.medium.y)
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: chatManager.currentConversation?.id)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.xl)
                    .padding(.top, DesignSystem.Spacing.xl)
                    
                    Spacer()
                },
                alignment: .top
            )
            
            // Sidebar Overlay
            if showingSidebar {
                // Background overlay to close sidebar when tapped
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showingSidebar = false
                        }
                        // Tastatur ausblenden
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
                // Sidebar content
                HStack {
                    SidebarView(chatManager: chatManager, onConversationSelected: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showingSidebar = false
                        }
                    })
                        .frame(width: 280)
                        .background(Color(.systemBackground))
                        .shadow(radius: 10, x: 5, y: 0)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    
                    Spacer()
                }
            }
        }
    }
}
