# LLM Chat Simple

Eine moderne iOS-Chat-Anwendung, die mit lokalen LLM-Servern kommuniziert. Entwickelt mit SwiftUI und optimiert für eine intuitive Benutzeroberfläche.

## ✨ Features

- **Moderne SwiftUI-Oberfläche** - Sauberes, responsives Design mit flüssigen Animationen
- **Mehrere Unterhaltungen** - Erstellen und verwalten Sie mehrere Chat-Threads
- **Lokaler LLM-Server** - Konfigurierbare Verbindung zu Ihrem eigenen LLM-Server
- **Persistente Speicherung** - Unterhaltungen werden automatisch gespeichert
- **Echtzeit-Chat** - Sofortige Antworten mit Lade-Animationen
- **Intuitive Navigation** - Sidebar mit Unterhaltungsübersicht
- **Einstellungen** - Konfigurierbare Server-IP und Port
- **Chat-Befehle** - `/clear` Befehl zum Löschen des aktuellen Chats

## 🚀 Installation

### Voraussetzungen

- iOS 16.0 oder höher
- Xcode 15.0 oder höher
- Ein laufender LLM-Server (z.B. Ollama, LM Studio, etc.)

### Setup

1. **Repository klonen**
   ```bash
   git clone https://github.com/ihr-username/LLMChatSimple.git
   cd LLMChatSimple
   ```

2. **Xcode-Projekt öffnen**
   ```bash
   open LLMChatSimple.xcodeproj
   ```

3. **API-Schlüssel konfigurieren**
   - Öffnen Sie `ChatManager.swift`
   - Ersetzen Sie `"IHR_OPENAI_API_SCHLÜSSEL_HIER"` mit Ihrem API-Schlüssel
   - Oder konfigurieren Sie Ihren lokalen Server (siehe Konfiguration)

4. **App im Simulator starten**
   - Wählen Sie einen iOS Simulator aus
   - Drücken Sie `Cmd + R` oder klicken Sie auf den Play-Button

## ⚙️ Konfiguration

### LLM-Server einrichten

Die App ist standardmäßig für einen lokalen Server konfiguriert:

1. **Server-IP konfigurieren**
   - Öffnen Sie die Sidebar (☰ Button)
   - Tippen Sie auf das Einstellungsrad (⚙️)
   - Geben Sie Ihre Server-IP und Port ein (z.B. `192.168.1.100:8080`)
   - Tippen Sie auf "Speichern"

2. **Unterstützte Server**
   - Ollama
   - LM Studio
   - Jeder OpenAI-kompatible Server

### API-Endpunkt

Die App erwartet einen OpenAI-kompatiblen Endpunkt:
```
POST http://ihre-server-ip:port/v1/chat/completions
```

**Request Body:**
```json
{
  "model": "mistral",
  "messages": [
    {
      "role": "user",
      "content": "Ihre Nachricht hier"
    }
  ],
  "max_tokens": 1000,
  "temperature": 0.7
}
```

## 📱 Verwendung

### Grundfunktionen

1. **Neue Unterhaltung starten**
   - Tippen Sie auf das `+` Symbol oben rechts
   - Oder verwenden Sie die Sidebar

2. **Nachricht senden**
   - Geben Sie Ihre Nachricht in das Textfeld ein
   - Tippen Sie auf das Papierflugzeug-Symbol oder drücken Sie Enter

3. **Unterhaltungen verwalten**
   - Öffnen Sie die Sidebar mit dem ☰ Button
   - Tippen Sie auf eine Unterhaltung zum Wechseln
   - Halten Sie eine Unterhaltung gedrückt zum Löschen

4. **Chat leeren**
   - Geben Sie `/clear` in das Textfeld ein
   - Der aktuelle Chat wird gelöscht

### Sidebar-Navigation

- **☰ Button** - Sidebar öffnen/schließen
- **+ Button** - Neue Unterhaltung erstellen
- **⚙️ Button** - Einstellungen öffnen

## 🏗️ Architektur

### Hauptkomponenten

- **`LLMChatApp`** - App-Entry-Point
- **`ContentView`** - Hauptansicht mit Navigation
- **`ChatView`** - Chat-Interface
- **`ChatManager`** - State Management und API-Kommunikation
- **`SidebarView`** - Unterhaltungsübersicht und Einstellungen
- **`MessageView`** - Einzelne Nachrichtenanzeige

### Datenmodelle

- **`Conversation`** - Chat-Unterhaltung mit Titel und Nachrichten
- **`Message`** - Einzelne Nachricht mit Rolle und Inhalt
- **`MessageRole`** - User oder Assistant

## 🔧 Entwicklung

### Projektstruktur

```
LLMChatSimple/
├── LLMChatApp.swift          # App Entry Point
├── ContentView.swift         # Hauptansicht
├── ChatView.swift           # Chat Interface
├── ChatManager.swift        # State Management
├── SidebarView.swift        # Sidebar Navigation
├── MessageView.swift        # Nachrichtenkomponente
└── DesignSystem.swift       # Design System (falls vorhanden)
```

### Build & Test

```bash
# Projekt kompilieren
xcodebuild -project LLMChatSimple.xcodeproj -scheme LLMChatSimple -destination 'platform=iOS Simulator,name=iPhone 16' build

# App im Simulator installieren
xcrun simctl install "iPhone 16" "path/to/LLMChatSimple.app"

# App starten
xcrun simctl launch "iPhone 16" com.example.LLMChatSimple
```

## 🎨 Design

Die App verwendet ein modernes, minimalistisches Design mit:

- **Farben**: System-Farben mit blauem Akzent
- **Animationen**: Spring-Animationen für flüssige Übergänge
- **Layout**: Adaptive Layouts für verschiedene Bildschirmgrößen
- **Typografie**: System-Schriftarten für optimale Lesbarkeit

## 🤝 Beitragen

1. Fork das Repository
2. Erstellen Sie einen Feature-Branch (`git checkout -b feature/AmazingFeature`)
3. Committen Sie Ihre Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Pushen Sie zum Branch (`git push origin feature/AmazingFeature`)
5. Öffnen Sie einen Pull Request

## 📄 Lizenz

Dieses Projekt steht unter der MIT-Lizenz. Siehe `LICENSE` Datei für Details.

## 🐛 Bekannte Probleme

- API-Schlüssel muss manuell in `ChatManager.swift` konfiguriert werden
- Server-Verbindung wird nicht automatisch validiert
- Keine Offline-Funktionalität

## 🔮 Geplante Features

- [ ] Automatische Server-Erkennung
- [ ] Mehrere LLM-Modelle unterstützen
- [ ] Export/Import von Unterhaltungen
- [ ] Dark Mode Optimierungen
- [ ] Voice-to-Text Integration
- [ ] Chat-Sharing Funktionalität

## 📞 Support

Bei Fragen oder Problemen:

1. Überprüfen Sie die [Issues](https://github.com/ihr-username/LLMChatSimple/issues)
2. Erstellen Sie ein neues Issue mit detaillierter Beschreibung
3. Kontaktieren Sie den Entwickler

---

**Entwickelt mit ❤️ in SwiftUI**
