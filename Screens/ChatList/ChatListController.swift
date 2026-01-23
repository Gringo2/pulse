import UIKit

final class ChatListController: UIViewController {
    
    private var state: ChatListState
    private let node = ChatListNode()
    
    init() {
        self.state = .initial
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        self.view = node
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupNodeCallbacks()
        handle(.loadData)
    }
    
    private func setupNavigation() {
        title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Premium Transparent Appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = Theme.Colors.accent
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapNewChat)
        )
    }
    
    @objc private func didTapNewChat() {
        let search = UserSearchController()
        search.onSelectUser = { [weak self] userId in
            self?.startChat(topic: userId)
        }
        
        let nav = UINavigationController(rootViewController: search)
        // Match main nav appearance if possible, or default
        nav.navigationBar.barStyle = .black
        nav.navigationBar.tintColor = Theme.Colors.accent
        
        present(nav, animated: true)
    }
    
    private func startChat(topic: String) {
        // Optimistically nav to chat. 
        // In a real app, we'd wait for 'ctrl' success or 'pres' existence.
        // For verifying integration, we just try to subscribe then open.
        
        let chat = Chat(
            id: topic,
            name: topic, // Will update when we get info
            messagePreview: "New conversation",
            timestamp: Date(),
            unreadCount: 0,
            isOnline: false,
            avatarName: "person.circle"
        )
        
        // Subscription will happen inside ChatController.init or via the navigation flow logic?
        // Current implementation: ChatController.init -> subscribes.
        // So just navigating is enough.
        navigateToChat(chat)
    }
    
    private func setupNodeCallbacks() {
        // Events upward
        node.onSelectChat = { [weak self] chat in
            self?.handle(.didSelectChat(chat))
        }
        
        node.searchBar.onTextChanged = { [weak self] query in
            self?.filterChats(query: query)
        }
    }
    
    private func filterChats(query: String) {
        // Ideally state should hold 'all' and 'filtered' separate
        // For this simple mock, we might lose data if we overwrite state.chats.
        // Let's assume we reload for now or need a better state model.
        // OR better: Request a filter event.
        
        // Since we don't have a full redux/store here, let's just do inline filtering on a shadow copy
        // Or just re-trigger load if empty. 
        // Quickest path: Filter visible items.
        // But wait, the standard way is:
        // handle(.filter(query)) -> update state -> update UI
        
        // Let's implement basic local filtering on the current dataset for the demo
        if query.isEmpty {
            // Restore? We need the original source.
            handle(.loadData) // Re-fetch (mock)
        } else {
            let filtered = state.chats.filter { $0.name.lowercased().contains(query.lowercased()) }
            var newState = state
            newState.chats = filtered
            node.update(state: newState)
        }
    }
    
    @objc private func didTapSettings() {
        handle(.didTapSettings)
    }
    
    // MARK: - Event Loop
    
    private func handle(_ event: ChatListEvent) {
        switch event {
        case .loadData:
            state.isLoading = true
            updateUI()
            
            // Subscribe to 'me' to get our chat list
            TinodeClient.shared.subscribe(to: "me")
            
            // Handle incoming metadata
            TinodeClient.shared.onMeta = { [weak self] meta in
                guard let self = self, meta.topic == "me" else { return }
                
                let chats = meta.sub.map { sub in
                    var name = sub.topic
                    if let publicData = try? JSONSerialization.jsonObject(with: sub.public) as? [String: Any],
                       let fn = publicData["fn"] as? String {
                        name = fn
                    }
                    
                    return Chat(
                        id: sub.topic,
                        name: name,
                        messagePreview: "Seq: \(sub.seqID)", 
                        timestamp: Date(), // Ideally track .touched
                        unreadCount: Int(sub.seqID - sub.readID),
                        isOnline: sub.online,
                        avatarName: "person.circle"
                    )
                }
                
                self.state.chats = chats
                self.state.isLoading = false
                self.updateUI()
            }
            
            // Handle presence updates
            TinodeClient.shared.onPres = { [weak self] pres in
                guard let self = self else { return }
                
                // Find the chat and update its online status
                if let index = self.state.chats.firstIndex(where: { $0.id == pres.topic }) {
                    var updatedChat = self.state.chats[index]
                    updatedChat.isOnline = TinodeClient.shared.getPresence(for: pres.topic)
                    self.state.chats[index] = updatedChat
                    self.updateUI()
                }
            }
            
        case .didSelectChat(let chat):
            navigateToChat(chat)
            
        case .didTapSettings:
            navigateToSettings()
        }
    }
    
    private func updateUI() {
        node.update(state: state)
    }
    
    // MARK: - Navigation
    
    private func navigateToChat(_ chat: Chat) {
        // In the next step we will have ChatController
        // For now, temporarily using old or direct init logic, but best to defer to the Router pattern or simple push
        // We need to verify where ChatController is. It's moving to Screens/Chat.
        // Assuming ChatController is/will be available.
        let chatController = ChatController(chat: chat)
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    private func navigateToSettings() {
        let settings = SettingsController()
        navigationController?.pushViewController(settings, animated: true)
    }
}
