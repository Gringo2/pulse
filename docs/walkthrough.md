# Pulse v1 Walkthrough (Refactored)

Pulse v1 implements a high-performance architecture with strict separation of concerns.

## 🏗 Architecture Refactor (Controller-State-Node)

The project is organized to enforce the Controller-State-Event-Node pattern.

### The Pattern
1. **Controllers** (`Screens/Chat/ChatController.swift`)
   - Contain all business logic and state management.
   - Handle events from Nodes.
   - Update Nodes with `update(state:)`.
2. **State** (`Infrastructure/State.swift`, `ChatState.swift`)
   - Pure, immutable structs defining the UI at any point in time.
3. **Events** (`Infrastructure/Event.swift`)
   - Enums describing user actions (`sendMessage`, `didSelectChat`).
4. **Nodes** (`Components/Base/Node.swift`)
   - Passive `UIView` subclasses.
   - No business logic. No networking. Pure rendering.

## 📂 New Directory Structure

```
Pulse/
├── App/ (AppDelegate, RootController)
├── Infrastructure/ (State, Event, PerformanceMonitor)
├── Screens/
│   ├── ChatList/ (Controller + State + Node + CellNode)
│   ├── Chat/     (Controller + State + Node)
│   └── Settings/ (Controller + Node)
├── Components/
│   ├── Base/ (Node.swift)
│   ├── MessageBubble/
│   ├── InputPanel/
│   ├── MessageList/
│   └── Common/ (Switch, Slider)
├── Animation/ (Physics Engine)
└── Models/ (Chat, Message)
```

## ✅ Implementations

### Chat List
- **Controller**: Triggers "API" load, handles navigation events.
- **Node**: TableView wrapper that diffs/updates from `ChatListState`.

### Chat Screen
- **Controller**: Manages `ChatState`, handles `.sendMessage`, simulates replies.
- **Node**: Orchestrates `MessageListNode` and `InputPanelNode`. Uses `bottomInset` for keyboard handling.
- **Events**: Typed events (`.sendMessage(String)`) flow upward.

### Components
- **InputPanel**: Decoupled from logic. Uses closure/delegate to signal intent.
- **Physics**: Start-up animations (`SettingsController`) demonstrate liquid physics unrelated to business logic.

### 4. Performance Instrumentation
- **Tool**: `PerformanceMonitor`
- **Metric**: Real-time FPS overlay and Node count tracking.

## 🏗 Build System & CI

Pulse is now configured for automated build verification:
- **Swift Package Manager**: A `Package.swift` defines the project modules for `swift build`.
- **GitHub Actions**: A CI workflow (`build.yml`) validates compilation on both macOS and iOS (via Simulator check) on every push.

## 🚀 Status
The codebase is clean, modular, and strictly follows the senior-level architecture patterns required by the specification. It is ready for deployment to a CI/CD pipeline.
