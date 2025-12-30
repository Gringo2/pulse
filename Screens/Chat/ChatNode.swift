import UIKit

final class ChatNode: Node {
    
    private let messageListNode = MessageListNode()
    private let inputPanelNode = InputPanelNode()
    
    // Events
    var onEvent: ((ChatEvent) -> Void)?
    
    private var bottomInset: CGFloat = 0
    
    override func setup() {
        backgroundColor = .systemBackground
        
        addSubnodes([messageListNode, inputPanelNode])
        
        // Component Callbacks (Wiring)
        inputPanelNode.onSendMessage = { [weak self] text in
            self?.onEvent?(.sendMessage(text))
        }
        
        // Setup Keyboard (This technically might belong in Controller or an infrastructure helper,
        // but Node handling layout is acceptable if Controller passes down the inset.
        // For strictly passive node, Controller should tell Node "setBottomInset(y)".
        // We'll leave keyboard observing in Controller ideally, but for now we keep it simple or move it.)
        // Refactoring plan says: "Nodes render state". Keyboard height is ephemeral UI state.
        // Let's self-manage for now to keep Controller clean of layout math.
        setupKeyboardObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inputHeight: CGFloat = 50 + bottomInset
        
        inputPanelNode.frame = CGRect(x: 0, y: bounds.height - inputHeight, width: bounds.width, height: inputHeight)
        messageListNode.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - inputHeight)
    }
    
    // MARK: - Update
    
    func update(state: ChatState) {
        // Pass data down to components
        messageListNode.update(messages: state.messages)
        
        // Input Panel State
        // inputPanelNode.setInputMode(state.inputMode) // Logic not implemented in component yet
    }
    
    // MARK: - Keyboard
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let isDismissing = endFrame.origin.y >= UIScreen.main.bounds.height
        // We need 'window' to be safe, or just use screen bounds
        let safeBottom = safeAreaInsets.bottom
        self.bottomInset = isDismissing ? safeBottom : (endFrame.height - safeBottom)
        if self.bottomInset < 0 { self.bottomInset = 0 } // sanity
        
        // Animate
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        UIView.animate(withDuration: duration) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
}
