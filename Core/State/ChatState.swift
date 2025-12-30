import Foundation

enum InputMode {
    case text
    case recording
    case lockedRecording
    case media
}

struct Message: Identifiable {
    let id: UUID
    let text: String
    let isOutgoing: Bool
    let timestamp: Date
}

struct ChatState {
    var messages: [Message]
    var inputMode: InputMode
    var isRecording: Bool
    
    static let initial = ChatState(
        messages: [],
        inputMode: .text,
        isRecording: false
    )
}
