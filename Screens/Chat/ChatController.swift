import UIKit
import PhotosUI

final class ChatController: UIViewController, PHPickerViewControllerDelegate {
    
    private var state: ChatState
    private let chat: Chat // The chat context
    private let node = ChatNode()
    
    init(chat: Chat) {
        self.chat = chat
        self.state = .initial
        super.init(nibName: nil, bundle: nil)
        
        self.title = chat.name
        node.headerTitle.text = chat.name
        self.state.messages = [
            Message(id: UUID(), text: "Hello \(chat.name)!", isOutgoing: true, timestamp: Date().addingTimeInterval(-1000)),
            Message(id: UUID(), text: "Welcome to Pulse.", isOutgoing: false, timestamp: Date().addingTimeInterval(-500))
        ]
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        self.view = node
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCallbacks()
        // Custom header requested later, system nav hidden above
        updateUI()
    }
    
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapProfile)
        )
    }
    
    @objc private func didTapProfile() {
        let profile = ProfileController()
        navigationController?.pushViewController(profile, animated: true)
    }
    
    private func setupCallbacks() {
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
            
        case .didTapAttach:
            presentPicker()
            
        case .didTapBack:
            navigationController?.popViewController(animated: true)
            
        default:
            break
        }
    }
    
    private func presentPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - PHPickerViewControllerDelegate
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                if let _ = image as? UIImage {
                    // In a real app, we would upload this and send a message with the URL.
                    // For now, let's mock sending a message notification.
                    let msg = Message(id: UUID(), text: "📷 Image Attached", isOutgoing: true, timestamp: Date())
                    self?.state.messages.append(msg)
                    self?.updateUI()
                }
            }
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
