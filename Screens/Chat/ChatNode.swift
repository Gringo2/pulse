import UIKit

final class ChatNode: Node {
    
    private let messageListNode = MessageListNode()
    private let inputPanelNode = InputPanelNode()
    
    // Events
    var onEvent: ((ChatEvent) -> Void)?
    
    private var bottomInset: CGFloat = 0
    
    override func setup() {
        backgroundColor = Theme.Colors.background
        
        addSubnodes([messageListNode, inputPanelNode])
        
        // Component Callbacks (Wiring)
        inputPanelNode.onSendMessage = { [weak self] text in
            self?.onEvent?(.sendMessage(text))
        }
        
        setupKeyboardObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let safeBottom = safeAreaInsets.bottom
        let inputHeaderHeight: CGFloat = 52
        let inputTotalHeight = inputHeaderHeight + bottomInset + (bottomInset > 0 ? 0 : safeBottom)
        
        inputPanelNode.frame = CGRect(x: 0, y: bounds.height - inputTotalHeight, width: bounds.width, height: inputTotalHeight)
        
        // Ensure message list is below any header blur if we add one, 
        // but for now, it fills the remaining space.
        messageListNode.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - inputTotalHeight)
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
