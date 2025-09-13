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
                // Floating Action Buttons
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.2)) {
                                showingSidebar.toggle()
                            }
                        }) {
                            Image(systemName: showingSidebar ? "xmark" : "line.3.horizontal")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                                .scaleEffect(showingSidebar ? 1.1 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingSidebar)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                chatManager.createNewConversation()
                            }
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                                .scaleEffect(1.0)
                                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: chatManager.currentConversation?.id)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
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
