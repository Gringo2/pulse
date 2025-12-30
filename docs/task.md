# Pulse v1 Refactoring Tasks

- [x] **Infrastructure & Setup**
    - [x] Create `Infrastructure` folder and base types (`State`, `Event`) <!-- id: 0 -->
    - [x] Reorganize Directory Structure (App, Screens, Components) <!-- id: 1 -->
    - [x] Move `AppDelegate` and create `RootController` <!-- id: 2 -->

- [x] **Chat List Refactor**
    - [x] Create `ChatListState` and `ChatListEvent` <!-- id: 3 -->
    - [x] Update `ChatListController` to use Event/State pattern <!-- id: 4 -->
    - [x] Update `ChatListNode` to use `update(state:)` <!-- id: 5 -->

- [x] **Chat Screen Refactor**
    - [x] Create `ChatState` (move from Core) and `ChatEvent` <!-- id: 6 -->
    - [x] Update `ChatController` logic <!-- id: 7 -->
    - [x] Ensure `ChatNode` is passive renderer <!-- id: 8 -->

- [x] **Components & Animation**
    - [x] Move Animations to `Animation/` folder <!-- id: 9 -->
    - [x] Refactor `Components` to match new structure <!-- id: 10 -->

- [x] **Build System & CI/CD**
    - [x] Create `Package.swift` for build verification <!-- id: 11 -->
    - [x] Implement GitHub Actions workflow <!-- id: 12 -->
    - [x] Complete project cleanup and README <!-- id: 13 -->

- [x] **Branding & Assets**
    - [x] Design and integrate Pulse logo <!-- id: 14 -->
    - [x] Configure AppIcon asset catalog <!-- id: 15 -->
