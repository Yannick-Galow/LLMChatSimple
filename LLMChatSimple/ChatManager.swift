import SwiftUI

@MainActor
class ChatManager: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var currentConversation: Conversation?
    @Published var isLoading = false
    
    private let openAIAPI = OpenAIAPI()
    private let userDefaults = UserDefaults.standard
    private let conversationsKey = "saved_conversations"
    
    init() {
        loadConversations()
        // Immer eine neue Konversation beim App-Start erstellen
        createNewConversation()
    }
    
    var messages: [Message] {
        currentConversation?.messages ?? []
    }
    
    func sendMessage(_ content: String) async {
        guard var conversation = currentConversation else { return }
        
        let userMessage = Message(role: .user, content: content)
        conversation.addMessage(userMessage)
        updateCurrentConversation(conversation)
        
        isLoading = true
        
        do {
            let response = try await openAIAPI.sendMessage(content: content)
            let aiMessage = Message(role: .assistant, content: response)
            conversation.addMessage(aiMessage)
            updateCurrentConversation(conversation)
        } catch {
            let errorMessage = Message(
                role: .assistant,
                content: "Entschuldigung, es ist ein Fehler aufgetreten: \(error.localizedDescription)"
            )
            conversation.addMessage(errorMessage)
            updateCurrentConversation(conversation)
        }
        
        isLoading = false
    }
    
    func createNewConversation() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            let newConversation = Conversation()
            conversations.insert(newConversation, at: 0)
            currentConversation = newConversation
        }
        saveConversations()
    }
    
    func selectConversation(_ conversation: Conversation) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            currentConversation = conversation
        }
    }
    
    func deleteConversation(_ conversation: Conversation) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            conversations.removeAll { $0.id == conversation.id }
            if currentConversation?.id == conversation.id {
                currentConversation = conversations.first
            }
        }
        saveConversations()
    }
    
    func clearCurrentChat() {
        if let conversation = currentConversation {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                var clearedConversation = conversation
                clearedConversation.messages.removeAll()
                updateCurrentConversation(clearedConversation)
            }
        }
    }
    
    private func updateCurrentConversation(_ conversation: Conversation) {
        if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
            conversations[index] = conversation
        }
        currentConversation = conversation
        saveConversations()
    }
    
    private func saveConversations() {
        if let data = try? JSONEncoder().encode(conversations) {
            userDefaults.set(data, forKey: conversationsKey)
        }
    }
    
    private func loadConversations() {
        if let data = userDefaults.data(forKey: conversationsKey),
           let conversations = try? JSONDecoder().decode([Conversation].self, from: data) {
            self.conversations = conversations
        }
    }
}

struct Conversation: Identifiable, Codable {
    let id = UUID()
    var title: String
    var messages: [Message]
    let createdAt: Date
    var lastMessageAt: Date
    
    init(title: String = "Neue Unterhaltung", messages: [Message] = []) {
        self.title = title
        self.messages = messages
        self.createdAt = Date()
        self.lastMessageAt = Date()
    }
    
    mutating func addMessage(_ message: Message) {
        messages.append(message)
        lastMessageAt = Date()
        
        // Aktualisiere den Titel basierend auf der ersten Nachricht
        if messages.count == 1 && message.role == .user {
            let words = message.content.components(separatedBy: .whitespaces)
            if words.count > 1 {
                title = words.prefix(3).joined(separator: " ")
            } else {
                title = message.content
            }
        }
    }
}

struct Message: Identifiable, Codable {
    let id = UUID()
    let role: MessageRole
    let content: String
    let timestamp: Date
    
    init(role: MessageRole, content: String) {
        self.role = role
        self.content = content
        self.timestamp = Date()
    }
}

enum MessageRole: String, Codable {
    case user
    case assistant
}

class OpenAIAPI {
    private let apiKey = "IHR_OPENAI_API_SCHLÜSSEL_HIER" // Ersetzen Sie dies mit Ihrem API-Schlüssel
    private var baseURL: String {
        let savedIP = UserDefaults.standard.string(forKey: "llm_server_ip") ?? "192.168.0.234:1010"
        return "http://\(savedIP)/v1/chat/completions"
    }
    
    func sendMessage(content: String) async throws -> String {
        guard let url = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = [
            "model": "mistral",
            "messages": [
                [
                    "role": "user",
                    "content": content
                ]
            ],
            "max_tokens": 1000,
            "temperature": 0.7
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            throw APIError.encodingError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let firstChoice = choices.first,
                  let message = firstChoice["message"] as? [String: Any],
                  let content = message["content"] as? String else {
                throw APIError.invalidResponse
            }
            
            return content
        } catch {
            throw APIError.networkError(error)
        }
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case encodingError
    case networkError(Error)
    case invalidResponse
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Ungültige URL"
        case .encodingError:
            return "Fehler beim Kodieren der Anfrage"
        case .networkError(let error):
            return "Netzwerkfehler: \(error.localizedDescription)"
        case .invalidResponse:
            return "Ungültige Antwort vom Server"
        case .serverError(let code):
            return "Serverfehler: \(code)"
        }
    }
}
