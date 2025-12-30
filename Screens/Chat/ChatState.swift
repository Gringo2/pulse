import Foundation

enum ChatInputMode: Equatable {
    case text
    case recording
    case lockedRecording
    case media
}

struct ChatState: State {
    var messages: [Message]
    var inputMode: ChatInputMode
    var isRecording: Bool
    var isTyping: Bool
    
    static let initial = ChatState(
        messages: [],
        inputMode: .text,
        isRecording: false,
        isTyping: false
    )
}

enum ChatEvent: Event {
    case loadMessages
    case sendMessage(String)
    case messageReceived(Message)
    case setInputMode(ChatInputMode)
}
