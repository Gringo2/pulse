import UIKit

/// Controller for the Chat List.
/// Responsible for:
/// - Data fetching (Mock)
/// - Navigation logic
/// - Hosting the root Node
final class ChatListScreen: UIViewController {
    
    // The root node for this screen
    private let listNode = ChatListNode()
    
    override func loadView() {
        self.view = listNode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pulse"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Initial Data
        let chats = Chat.mockData()
        listNode.update(chats: chats)
        
        // Settings Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )
        
        // Navigation Handler
        listNode.onSelectChat = { [weak self] chat in
            self?.openChat(chat)
        }
    }
    
    private func openChat(_ chat: Chat) {
        let chatScreen = ChatScreen(chat: chat)
        navigationController?.pushViewController(chatScreen, animated: true)
    }
    
    @objc private func openSettings() {
        let settings = SettingsScreen()
        navigationController?.pushViewController(settings, animated: true)
    }
}
