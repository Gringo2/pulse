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
        
        // Subscribe to this specific topic with history
        TinodeClient.shared.subscribe(to: chat.id, withHistory: true)
        
        // Setup packet routing
        setupPacketRouting()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupPacketRouting() {
        TinodeClient.shared.onData = { [weak self] data in
            guard let self = self, data.topic == self.chat.id else { return }
            
            var text = String(data: data.content, encoding: .utf8) ?? ""
            // Tinode sends simple text as quoted JSON string e.g. "hello"
            if text.hasPrefix("\"") && text.hasSuffix("\"") {
                text = String(text.dropFirst().dropLast())
            }
            
            let isOutgoing = (data.fromUserID == TinodeClient.shared.myUserId)
            
            let message = Message(
                id: "\(data.seqID)",
                text: text,
                isOutgoing: isOutgoing,
                timestamp: Date(timeIntervalSince1970: Double(data.timestamp) / 1000.0)
            )
            
            // Merge and Sort Logic to handle History + Real-time
            if !self.state.messages.contains(where: { $0.id == message.id }) {
                self.state.messages.append(message)
                self.state.messages.sort { (m1, m2) -> Bool in
                    // Sort by Seq ID (assuming string id is "1", "2" etc)
                    let id1 = Int(m1.id) ?? 0
                    let id2 = Int(m2.id) ?? 0
                    return id1 < id2
                }
                self.updateUI()
            }
            
            // Send read receipt only for NEW incoming messages (at the bottom)
            // We assume if seqID is higher than current max, it's new.
            // Simplified check: Only if it's effectively the last message
            if !isOutgoing, let last = self.state.messages.last, last.id == message.id {
                TinodeClient.shared.sendNote(topic: self.chat.id, what: "read", seqId: data.seqID)
            }
        }
        
        // Handle read receipts
        TinodeClient.shared.onInfo = { [weak self] info in
            guard let self = self, info.topic == self.chat.id else { return }
            
            if info.what == "read" {
                // Update all messages up to seqID as read
                for (index, message) in self.state.messages.enumerated() where message.isOutgoing {
                    if let msgSeq = Int32(message.id), msgSeq <= info.seqID {
                        self.state.messages[index].status = .read
                    }
                }
                self.updateUI()
            }
        }
        
        // Handle typing indicators
        TinodeClient.shared.onPres = { [weak self] pres in
            guard let self = self, pres.topic == self.chat.id else { return }
            
            if pres.what == "typing" {
                self.state.isTyping = true
                self.updateUI()
                
                // Auto-hide after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.state.isTyping = false
                    self.updateUI()
                }
            }
        }
    }
    
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
            // 1. Optimistically add to UI (though Tinode will echo via {data})
            // For now, let's just publish and wait for server echo to avoid duplicates
            TinodeClient.shared.publish(text: text, to: chat.id)
            
        case .setInputMode(let mode):
            state.inputMode = mode
            updateUI()
            
        case .didTapAttach:
            presentPicker()
            
        case .didTapBack:
            navigationController?.popViewController(animated: true)
            
        case .loadMoreHistory:
            // Load older messages
            guard let oldestMessage = state.messages.first,
                  let oldestSeq = Int32(oldestMessage.id) else { return }
            
            TinodeClient.shared.getHistory(topic: chat.id, before: oldestSeq)
            // Messages will be received via onData callback and prepended
            
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
                    // self?.state.messages.append(msg)
                    // self?.updateUI()
                }
            }
        }
    }
    
    private func updateUI() {
        node.update(state: state)
    }
}
