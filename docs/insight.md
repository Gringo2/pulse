# The Project: “Pulse” – A Real-Time Communication UI Playground

Pulse is a high-performance inspired iOS app that focuses on UI systems, not backend complexity.

Think of it as:
- Modern UI architecture
- Slack-style interactions
- Apple-quality animations
- No heavy server dependency

## Core Idea (Why This Works)

Senior engineers care more about:
- How you structure UI
- How you manage state
- How you animate efficiently
- How you avoid UIKit pitfalls

Not about:
- Fancy backend
- Login systems
- Payment flows

So Pulse focuses on UI + performance, exactly like the contest.

## Architecture (This Is the Key Part)

You will intentionally mirror leading-edge iOS concepts:

The design uses a high-performance, asynchronous rendering philosophy even when not directly visible.

In Pulse:
- Every screen is composed of nodes
- Views are thin
- Logic lives in controllers / components

Example:
```
ChatScreenNode
 ├── MessageListNode
 │    ├── MessageBubbleNode
 │    ├── MediaMessageNode
 │    └── SystemMessageNode
 ├── InputPanelNode
 │    ├── TextInputNode
 │    ├── ActionButtonsNode
 └── OverlayEffectsNode
```

High-performance apps rarely use giant view controllers.

You will use:
- Small reusable components

Each component owns:
- Layout
- Animation
- Interaction logic

Example:
- GlassButtonComponent
- SwitchComponent
- SliderComponent
- TabBarComponent

This is exactly what you already did in the contest.

The architecture avoids hidden UIKit state.

You’ll use:
```swift
struct ChatState {
    var messages: [Message]
    var isRecording: Bool
    var inputMode: InputMode
}
```

UI updates happen via:
```swift
func update(state: ChatState)
```

This is huge in interviews.

## Features You Will Build (Showcase-Worthy)

### 1. Advanced Chat UI

Message bubbles with:
- Tap highlights
- Press animations
- Context menus
- Smooth scrolling under load (1000+ messages)

What this shows:
- Layout performance
- Cell reuse discipline
- Animation correctness

### 2. -Style Input Bar

- Voice recording button
- Attach menu
- Animated transitions between modes

You already did this logic in the contest — reuse the thinking.

### 3. Custom Animation Engine (Big Win)

Create a small internal module:
```
Animation/
 ├── SpringAnimator.swift
 ├── HighlightAnimator.swift
```

Use:
- Damping ratios
- Mass / stiffness
- Time-based interpolation

This directly proves your Liquid Glass competence.

### 4. Performance Constraints (Critical)

Force constraints like those in massive scale apps:
- No blocking main thread
- No layout thrashing
- No unnecessary re-render

Add:
- Debug overlay showing FPS
- Animation cost logging

This screams “senior”.

## Tech Stack (Matches Modern Thinking)

**Required**
- Swift
- UIKit (not SwiftUI)
- CoreAnimation
- CALayer animations
- Dispatch queues

**Optional but Powerful**
- Texture (AsyncDisplayKit) if you can
- Otherwise: manual async layout

Even if you don’t use Texture, thinking like it is enough.

## Repo Structure (Interview-Ready)

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

This mirrors best-practice repo logic.

## How This Helps in Interviews

If you pass the contest, they may ask:
“What iOS apps have you built?”

You say:
“I built Pulse — a high-performance communication UI system focused on speed, animation physics, and component-driven architecture.”

Then you show:
- Code structure
- Animation engine
- State updates
- UI responsiveness

That’s exactly what they want.

## Very Important Reality (Your Mac Limitation)

You do not need to fully ship Pulse on the App Store.

Your work already proves you can integrate into complex codebases.
Pulse proves you can design systems from scratch.
