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
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(didTapEdit)
        )
    }
    
    @objc private func didTapEdit() {
        // Implement edit logic
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
            // Simulate Side Effect (API Call)
            state.isLoading = true
            updateUI() // Show loading if node supports it
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                // Generate more data for scrolling
                var mockChats = Chat.mockData()
                // Duplicate to fill list
                mockChats.append(contentsOf: mockChats.map { 
                    var copy = $0
                    copy.id = UUID()
                    return copy 
                })
                mockChats.append(contentsOf: mockChats.map { 
                    var copy = $0
                    copy.id = UUID()
                    return copy 
                })
                
                self.state.chats = mockChats
                self.state.isLoading = false
                self.updateUI()
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
