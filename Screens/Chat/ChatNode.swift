import UIKit

final class ChatNode: Node {
    
    private let messageListNode = MessageListNode()
    private let inputPanelNode = InputPanelNode()
    private let backButton = UIButton(type: .system)
    private let headerTitle = UILabel()
    private let headerBlur = GlassNode()
    private let typingIndicator = TypingIndicatorNode()
    
    // Events
    var onEvent: ((ChatEvent) -> Void)?
    
    private var bottomInset: CGFloat = 0
    
    private let backgroundLayer = CAGradientLayer()
    
    override func setup() {
        backgroundColor = Theme.Colors.background
        
        // Vibrant background gradient
        backgroundLayer.colors = [
            UIColor(hex: "#050505").cgColor,
            UIColor(hex: "#121424").cgColor,
            UIColor(hex: "#050505").cgColor
        ]
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        backgroundLayer.locations = [0.0, 0.4, 1.0]
        addSubnodes([backgroundLayer, messageListNode, typingIndicator, headerBlur, inputPanelNode])
        headerBlur.contentView.addSubnodes([backButton, headerTitle])
        
        typingIndicator.isHidden = true
        
        // Header Setup
        headerBlur.setBlurStyle(.systemUltraThinMaterialDark)
        headerTitle.font = .systemFont(ofSize: 17, weight: .bold)
        headerTitle.textColor = .white
        headerTitle.textAlignment = .center
        
        let backConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: backConfig), for: .normal)
        backButton.tintColor = Theme.Colors.accent
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        // Component Callbacks (Wiring)
        inputPanelNode.onSendMessage = { [weak self] text in
            self?.onEvent?(.sendMessage(text))
        }
        
        inputPanelNode.onAttach = { [weak self] in
            self?.onEvent?(.didTapAttach)
        }
        
        messageListNode.onScrollToTop = { [weak self] in
            self?.onEvent?(.loadMoreHistory)
        }
        
        setupKeyboardObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        
        let safeTop = safeAreaInsets.top
        let safeBottom = safeAreaInsets.bottom
        let headerHeight = safeTop + 44
        
        headerBlur.frame = CGRect(x: 0, y: 0, width: bounds.width, height: headerHeight)
        backButton.frame = CGRect(x: 8, y: safeTop, width: 44, height: 44)
        headerTitle.frame = CGRect(x: 60, y: safeTop, width: bounds.width - 120, height: 44)
        
        let inputHeaderHeight: CGFloat = 52
        let inputTotalHeight = inputHeaderHeight + bottomInset + (bottomInset > 0 ? 8 : safeBottom + 8)
        
        inputPanelNode.frame = CGRect(x: 0, y: bounds.height - inputTotalHeight, width: bounds.width, height: inputTotalHeight)
        
        // Message list fills the rest
        messageListNode.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        // Set insets so content doesn't hide under header/input
        messageListNode.tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: inputTotalHeight, right: 0)
        messageListNode.tableView.scrollIndicatorInsets = messageListNode.tableView.contentInset
        
        // Typing indicator just above input panel
        let typingY = bounds.height - inputTotalHeight - 44
        typingIndicator.frame = CGRect(x: 0, y: typingY, width: bounds.width, height: 44)
    }
    
    @objc private func didTapBack() {
        onEvent?(.didTapBack)
    }
    
    // MARK: - Update
    
    func update(state: ChatState) {
        // Pass data down to components
        messageListNode.update(messages: state.messages)
        
        // Typing indicator
        if state.isTyping {
            typingIndicator.isHidden = false
            typingIndicator.startAnimating()
        } else {
            typingIndicator.isHidden = true
            typingIndicator.stopAnimating()
        }
        
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
