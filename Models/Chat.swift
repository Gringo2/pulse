import Foundation

struct Chat: Identifiable {
    let id: UUID
    let name: String
    let messagePreview: String
    let timestamp: Date
    let unreadCount: Int
    let isOnline: Bool
    let avatarName: String? // SF Symbol name for demo
    
    // Derived for UI
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    static func mockData() -> [Chat] {
        return [
            Chat(id: UUID(), name: "Pavel Durov", messagePreview: "Architecture is key 🔑", timestamp: Date(), unreadCount: 3, isOnline: true, avatarName: "person.crop.circle.fill"),
            Chat(id: UUID(), name: "Design Team", messagePreview: "New assets for Pulse v1", timestamp: Date().addingTimeInterval(-300), unreadCount: 0, isOnline: false, avatarName: "paintpalette.fill"),
            Chat(id: UUID(), name: "Saved Messages", messagePreview: "Video_2025.mov", timestamp: Date().addingTimeInterval(-3600), unreadCount: 0, isOnline: true, avatarName: "bookmark.fill")
        ]
    }
}
