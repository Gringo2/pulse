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
        title = "Pulse"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupNavigation()
        setupNodeCallbacks()
        
        // Initial Effect
        handle(.loadData)
    }
    
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(didTapSettings)
        )
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
                self.state.chats = Chat.mockData()
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
