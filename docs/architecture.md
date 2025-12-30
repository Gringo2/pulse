# Pulse v1 – Functional Architecture Diagram

## High-Level Principle (Core Unidirectional Flow)
**State flows downward. Events flow upward. Rendering is passive.**
No magic. No hidden side effects.

## 1. Top-Level Architecture
```
AppDelegate
   ↓
RootController
   ↓
ScreenController (ChatList / Chat)
   ↓
ScreenNode
   ↓
Component Nodes
```

## 2. Layer Breakdown
### 2.1 Controllers (Brains)
- Own state
- Handle events
- Decide what changes
- **Do NOT**: Animate, Layout, Draw

### 2.2 Nodes (Renderers)
- Render state
- Own CALayers
- Perform animations
- **Do NOT**: Fetch data, Decide logic, Mutate global state

### 2.3 Components (Reusable Building Blocks)
- Components are small, isolated, testable.

## 3. State Flow Diagram
```
User Action
   ↓
Event (Tap / Gesture)
   ↓
Controller.handleEvent()
   ↓
New State Computed
   ↓
Node.update(state)
   ↓
Layers Updated / Animations Triggered

![Architecture Flow](assets/architecture_diagram.svg)

![Interaction Sequence](assets/interaction_sequence.svg)
```

## 4. Repo Structure (Refined Layout)
```
Pulse/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── RootController.swift
│
├── Screens/
│   ├── ChatList/
│   │   ├── ChatListController.swift
│   │   ├── ChatListState.swift
│   │   └── ChatListNode.swift
│   │
│   └── Chat/
│       ├── ChatController.swift
│       ├── ChatState.swift
│       └── ChatNode.swift
│
├── Components/
│   ├── MessageBubble/
│   │   ├── MessageBubbleNode.swift
│   │   └── MessageBubbleLayout.swift
│   │
│   └── InputPanel/
│       ├── InputPanelNode.swift
│       └── InputPanelState.swift
│
├── Animation/
│   ├── InteractionAnimator.swift
│   └── SpringAnimator.swift
│
├── Infrastructure/
│   ├── Event.swift
│   ├── State.swift
│   └── Disposable.swift
│
└── Resources/
    └── Assets.xcassets
```

## 5. Core Architecture Rules
1. **Controllers Own State**: `struct ChatState { ... }`
2. **Nodes Render State**: `func update(state: ChatState)`
3. **Events Flow Up**: `enum ChatEvent { ... }`

## 6. Performance Strategy
- CALayer-backed views
- Minimal subview depth
- Precompute sizes where possible
- CoreAnimation over UIView.animate

![Threading Model](assets/threading_model.svg)

![Layout Lifecycle](assets/layout_lifecycle.svg)
