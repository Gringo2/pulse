# Pulse v1 – Feature Specification

**Purpose**: Demonstrate high-end iOS architecture, animation systems, and performance-first UI engineering.

## 1. Product Vision

Pulse is a performance-focused iOS communication UI playground inspired by industry-leading architectures. It demonstrates component-driven UI composition, explicit state management, and physics-based interaction animations without relying on third-party UI frameworks. The project prioritizes smooth interactions, predictable state updates, and scalability across older iOS versions.

## 2. Scope

| Pulse v1 IS | Pulse v1 IS NOT |
| :--- | :--- |
| ✅ UI-centric | ❌ A full messaging backend |
| ✅ Animation-heavy | ❌ Network-heavy |
| ✅ Architecture-focused | ❌ Feature-bloated |
| ✅ Deterministic and testable | ❌ SwiftUI-based |

## 3. Core Screens

### 3.1 Chat List Screen
**Purpose**: Prove list performance and state updates.
- **Features**: List of chats, Unread badge, Online indicator, Tap highlight + scale animation.
- **What This Shows**: Cell reuse discipline, Animation without jank, Predictable state rendering.

### 3.2 Chat Screen (Main Focus)
**Components**:
- `MessageListNode`
- `MessageBubbleNode`
- `InputPanelNode`

**Message Types**: Text, System, Voice placeholder.
**Interactions**: Tap highlight (40ms), Press & hold bounce, Context menu trigger, Smooth scroll.

### 3.3 Input Panel
- **Modes**: Text input, Voice recording, Attach menu.
- **Animations**: Button scale-up, Glass-style highlight, Smooth transitions.
- **Constraints**: No layout jumps, No frame drops.

### 3.4 Settings Playground
**Purpose**: Reuse contest logic (Liquid Glass).
- Custom switch, Custom slider, Toggle animations.

## 4. State Management
**Central Rule**: UI never reads global state directly.

```swift
struct ChatState {
    let messages: [Message]
    let inputMode: InputMode
    let isRecording: Bool
}
// UI updates only via:
func update(state: ChatState)
```

## 5. Animation System
**Internal Module**: `Animation/`
- `SpringAnimator.swift`
- `HighlightAnimator.swift`

**Spec**:
- Tap highlight: 40ms
- Scale-up: 1.04x
- Bounce: ζ ≈ 1.0
- Gesture follow: Position-based

## 6. Performance Constraints
- Never block main thread
- Avoid layout thrashing
- Use minimal view hierarchy
- Reuse layers where possible
- **Debug Overlay**: FPS counter, Active animations count.

## 7. File Structure
```
Pulse/
├── App/            (Root coordination)
├── Infrastructure/ (State, Event, Performance)
├── Screens/        (Feature modules)
├── Components/     (Reusable Nodes)
├── Models/         (Data entities)
├── Animation/      (Physics Engine)
└── Resources/      (Assets)
```

## 8. What Pulse v1 Proves
- **UI architecture**: Node-based components
- **Animation mastery**: Physics engine
- **Performance awareness**: Explicit constraints
- **Contest relevance**: Liquid Glass reuse
- **Senior thinking**: Scoped features
