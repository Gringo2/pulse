import Foundation

struct ChatListState: State {
    var chats: [Chat]
    var isLoading: Bool
    
    static let initial = ChatListState(chats: [], isLoading: true)
}

enum ChatListEvent: Event {
    case loadData
    case didSelectChat(Chat)
    case didTapSettings
}
