# LLM Chat Simple

Eine moderne iOS-Chat-Anwendung mit sauberem, minimalistischem Design für den täglichen Gebrauch. Entwickelt mit SwiftUI und optimiert für eine intuitive Benutzeroberfläche.

## ✨ Features

### 🎨 **Modernes Design**
- **Sauberes, minimalistisches Interface** - Optimiert für den täglichen Gebrauch
- **Moderne Message-Bubbles** - Mit Gradient-Hintergründen und Schatten
- **Elegante Eingabe-Bereich** - Mit animiertem Send-Button und Fokus-Indikator
- **Willkommens-Screen** - Mit schönen Icons und Animationen
- **Smooth Scrolling** - Auto-Scroll zu neuen Nachrichten

### 💬 **Chat-Funktionen**
- **Mehrere Unterhaltungen** - Erstellen und verwalten Sie mehrere Chat-Threads
- **Lokaler LLM-Server** - Konfigurierbare Verbindung zu Ihrem eigenen LLM-Server
- **Persistente Speicherung** - Unterhaltungen werden automatisch gespeichert
- **Echtzeit-Chat** - Sofortige Antworten mit Lade-Animationen
- **Chat-Befehle** - `/clear` zum Löschen und `/new` für neue Gespräche

### 🗂️ **Navigation & Verwaltung**
- **Intuitive Sidebar** - Moderne Navigation mit Gesprächsübersicht
- **Long Press zum Löschen** - Gedrückt halten (0.5s) auf Gespräche zum Löschen
- **Gespräch löschen** - Button zum Löschen des aktuellen Gesprächs
- **Automatische Navigation** - Wechselt zum nächsten Gespräch nach dem Löschen

### ⚡ **Performance & UX**
- **Spring-Animationen** - Flüssige Übergänge und Micro-Interactions
- **Touch-Optimiert** - 44px Touch-Targets für optimale Bedienbarkeit
- **Responsive Design** - Adaptive Layouts für verschiedene Bildschirmgrößen
- **Focus Management** - Intelligente Tastatur-Behandlung

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

3. **App im Simulator starten**
   ```bash
   # Kompilieren
   xcodebuild -project LLMChatSimple.xcodeproj -scheme LLMChatSimple -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build
   
   # Installieren
   xcrun simctl install "iPhone 16 Pro" /Users/yg/Library/Developer/Xcode/DerivedData/LLMChatSimple-etmdinbpqaoooicjxsmrmlltzyoj/Build/Products/Debug-iphonesimulator/LLMChatSimple.app
   
   # Starten
   xcrun simctl launch "iPhone 16 Pro" com.example.LLMChatSimple
   ```

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
   - Tippen Sie auf "Neue Unterhaltung" in der Sidebar
   - Oder verwenden Sie den `/new` Befehl

2. **Nachricht senden**
   - Geben Sie Ihre Nachricht in das moderne Textfeld ein
   - Tippen Sie auf den animierten Send-Button oder drücken Sie Enter
   - Der Button wechselt zwischen Plus (+) und Pfeil (↑) je nach Inhalt

3. **Unterhaltungen verwalten**
   - Öffnen Sie die Sidebar mit dem ☰ Button
   - Tippen Sie auf eine Unterhaltung zum Wechseln
   - **Gedrückt halten** (0.5s) auf eine Unterhaltung zum Löschen
   - Verwenden Sie "Gespräch löschen" für das aktuelle Gespräch

4. **Chat-Befehle**
   - `/clear` - Löscht den aktuellen Chat
   - `/new` - Erstellt eine neue Unterhaltung

### Sidebar-Navigation

- **☰ Button** - Sidebar öffnen/schließen
- **Neue Unterhaltung** - Button zum Erstellen neuer Gespräche
- **Gespräch löschen** - Button zum Löschen des aktuellen Gesprächs
- **⚙️ Button** - Einstellungen öffnen

## 🏗️ Architektur

### Hauptkomponenten

- **`LLMChatApp`** - App-Entry-Point
- **`ContentView`** - Hauptansicht mit modernem Card-Layout
- **`ChatView`** - Chat-Interface mit modernen Message-Bubbles
- **`ChatManager`** - State Management und API-Kommunikation
- **`SidebarView`** - Moderne Unterhaltungsübersicht mit Long Press
- **`MessageView`** - Moderne Nachrichtenanzeige mit Gradienten
- **`DesignSystem`** - Zentralisiertes Design System

### Datenmodelle

- **`Conversation`** - Chat-Unterhaltung mit Titel und Nachrichten
- **`Message`** - Einzelne Nachricht mit Rolle und Inhalt
- **`MessageRole`** - User oder Assistant

## 🎨 Design System

### Farben
- **Primary**: System Blue
- **Secondary**: System Gray
- **Background**: System Background
- **Message Bubbles**: Gradient-Hintergründe

### Typografie
- **Titel**: .title2, .semibold
- **Body**: .body, .regular
- **Caption**: .caption2, .secondary

### Animationen
- **Spring-Animationen** für alle Interaktionen
- **Scale-Effekte** für Buttons
- **Fade-Transitions** für Nachrichten
- **Smooth Scrolling** mit Auto-Scroll

## 🔧 Entwicklung

### Projektstruktur

```
LLMChatSimple/
├── LLMChatApp.swift          # App Entry Point
├── ContentView.swift         # Hauptansicht mit modernem Layout
├── ChatView.swift           # Chat Interface mit modernen Bubbles
├── ChatManager.swift        # State Management
├── SidebarView.swift        # Sidebar mit Long Press Funktionalität
├── MessageView.swift        # Moderne Nachrichtenkomponente
└── DesignSystem.swift       # Zentralisiertes Design System
```

### Build & Test

```bash
# Projekt kompilieren
xcodebuild -project LLMChatSimple.xcodeproj -scheme LLMChatSimple -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build

# App im Simulator installieren
xcrun simctl install "iPhone 16 Pro" /Users/yg/Library/Developer/Xcode/DerivedData/LLMChatSimple-etmdinbpqaoooicjxsmrmlltzyoj/Build/Products/Debug-iphonesimulator/LLMChatSimple.app

# App starten
xcrun simctl launch "iPhone 16 Pro" com.example.LLMChatSimple
```

## 🎯 Benutzerfreundlichkeit

### Touch-Optimierung
- **44px Touch-Targets** für alle interaktiven Elemente
- **Long Press Gestures** (0.5s) für Kontext-Aktionen
- **Haptic Feedback** für wichtige Aktionen

### Accessibility
- **VoiceOver Support** für alle UI-Elemente
- **Dynamic Type** Unterstützung
- **High Contrast** Mode kompatibel

## 🤝 Beitragen

1. Fork das Repository
2. Erstellen Sie einen Feature-Branch (`git checkout -b feature/AmazingFeature`)
3. Committen Sie Ihre Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Pushen Sie zum Branch (`git push origin feature/AmazingFeature`)
5. Öffnen Sie einen Pull Request

## 📄 Lizenz

Dieses Projekt steht unter der MIT-Lizenz. Siehe `LICENSE` Datei für Details.

## 🐛 Bekannte Probleme

- Server-Verbindung wird nicht automatisch validiert
- Keine Offline-Funktionalität
- Long Press funktioniert nur im Simulator (Touch-Geräte benötigen physische Berührung)

## 🔮 Geplante Features

- [ ] Automatische Server-Erkennung
- [ ] Mehrere LLM-Modelle unterstützen
- [ ] Export/Import von Unterhaltungen
- [ ] Dark Mode Optimierungen
- [ ] Voice-to-Text Integration
- [ ] Chat-Sharing Funktionalität
- [ ] Haptic Feedback für Long Press
- [ ] Swipe-to-Delete Gestures

## 📞 Support

Bei Fragen oder Problemen:

1. Überprüfen Sie die [Issues](https://github.com/ihr-username/LLMChatSimple/issues)
2. Erstellen Sie ein neues Issue mit detaillierter Beschreibung
3. Kontaktieren Sie den Entwickler

---

**Entwickelt mit ❤️ in SwiftUI für ein modernes, tägliches Chat-Erlebnis**