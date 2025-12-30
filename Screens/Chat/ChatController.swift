import UIKit

final class ChatController: UIViewController {
    
    private var state: ChatState
    private let chat: Chat // The chat context
    
    // The main view node
    private let node = ChatNode()
    
    init(chat: Chat) {
        self.chat = chat
        self.state = .initial
        super.init(nibName: nil, bundle: nil)
        
        // Setup Initial State with some inputs
        self.title = chat.name
        
        // Mock loading existing messages
        self.state.messages = [
            Message(id: UUID(), text: "Hello \(chat.name)!", isOutgoing: true, timestamp: Date().addingTimeInterval(-1000)),
            Message(id: UUID(), text: "Welcome to Pulse.", isOutgoing: false, timestamp: Date().addingTimeInterval(-500))
        ]
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        self.view = node
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCallbacks()
        updateUI() // Initial render
    }
    
    private func setupCallbacks() {
        // Events from Node -> Controller
        node.onEvent = { [weak self] event in
            self?.handle(event)
        }
    }
    
    // MARK: - Event Loop
    private func handle(_ event: ChatEvent) {
        switch event {
        case .sendMessage(let text):
            let msg = Message(id: UUID(), text: text, isOutgoing: true, timestamp: Date())
            state.messages.append(msg)
            
            // Optimistic update
            updateUI()
            
            // Simulate Reply
            simulateReply(to: text)
            
        case .setInputMode(let mode):
            state.inputMode = mode
            updateUI()
            
        default:
            break
        }
    }
    
    private func updateUI() {
        node.update(state: state)
    }
    
    private func simulateReply(to text: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            let reply = Message(id: UUID(), text: "Reply to: \(text)", isOutgoing: false, timestamp: Date())
            self.state.messages.append(reply)
            self.updateUI()
        }
    }
}
