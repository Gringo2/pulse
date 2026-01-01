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
                    copy.id = $0.id + " copy"
                    return copy 
                })
                mockChats.append(contentsOf: mockChats.map { 
                    var copy = $0
                    copy.id = $0.id + " copy 2"
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
