import Foundation

enum CallStatus: String {
    case incoming
    case outgoing
    case missed
}

struct Call: Identifiable, Equatable {
    let id: UUID
    let name: String
    let status: CallStatus
    let date: Date
    let avatarName: String?
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var statusIconName: String {
        switch status {
        case .incoming: return "arrow.down.left"
        case .outgoing: return "arrow.up.right"
        case .missed: return "exclamationmark"
        }
    }
    
    static func mockData() -> [Call] {
        return [
            Call(id: UUID(), name: "Pavel Durov", status: .incoming, date: Date().addingTimeInterval(-1200), avatarName: "person.crop.circle.fill"),
            Call(id: UUID(), name: "Design Team", status: .missed, date: Date().addingTimeInterval(-3600), avatarName: "paintpalette.fill"),
            Call(id: UUID(), name: "Mom", status: .outgoing, date: Date().addingTimeInterval(-7200), avatarName: "heart.fill"),
            Call(id: UUID(), name: "Elon Musk", status: .missed, date: Date().addingTimeInterval(-10000), avatarName: "bolt.fill"),
             Call(id: UUID(), name: "Pavel Durov", status: .incoming, date: Date().addingTimeInterval(-1200), avatarName: "person.crop.circle.fill"),
            Call(id: UUID(), name: "Design Team", status: .missed, date: Date().addingTimeInterval(-3600), avatarName: "paintpalette.fill"),
            Call(id: UUID(), name: "Mom", status: .outgoing, date: Date().addingTimeInterval(-7200), avatarName: "heart.fill"),
            Call(id: UUID(), name: "Elon Musk", status: .missed, date: Date().addingTimeInterval(-10000), avatarName: "bolt.fill")
        ]
    }
}
