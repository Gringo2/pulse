import UIKit

/// The complex input panel of Pulse.
/// Features:
/// - Text Input
/// - Voice Mode Toggle
/// - Attachment Menu
/// - Glass styling
final class InputPanelNode: Node, UITextFieldDelegate {
    
    // UI Elements
    private let glassBackground = GlassNode()
    private let textField = UITextField()
    private let voiceButton = UIButton(type: .system)
    private let attachButton = UIButton(type: .system)
    private let sendButton = UIButton(type: .system)
    
    var onSendMessage: ((String) -> Void)?
    
    override func setup() {
        // Glass Background (Full width at bottom)
        glassBackground.layer.cornerRadius = 0
        glassBackground.layer.borderWidth = 0 // Handled by top border if needed
        glassBackground.setBlurStyle(.systemUltraThinMaterialDark)
        
        let topBorder = UIView()
        topBorder.backgroundColor = Theme.Colors.glassBorder
        topBorder.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        topBorder.frame = CGRect(x: 0, y: 0, width: 2000, height: 0.5)
        glassBackground.addSubview(topBorder)
        
        // Buttons
        configureButton(attachButton, icon: "plus")
        configureButton(voiceButton, icon: "mic")
        
        // Send Button (Premium Circular blue)
        sendButton.backgroundColor = Theme.Colors.accent
        sendButton.setImage(UIImage(systemName: "arrow.up")?.withConfiguration(UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
        sendButton.tintColor = .white
        sendButton.layer.cornerRadius = 16
        sendButton.isHidden = true
        sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        
        // Text Field
        textField.placeholder = "Message"
        textField.attributedPlaceholder = NSAttributedString(
            string: "Message",
            attributes: [.foregroundColor: Theme.Colors.secondaryText]
        )
        textField.borderStyle = .none
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        textField.layer.cornerRadius = 20
        textField.layer.borderColor = Theme.Colors.glassBorder.cgColor
        textField.layer.borderWidth = 0.5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        textField.leftViewMode = .always
        textField.delegate = self
        textField.returnKeyType = .send
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        addSubnodes([glassBackground, attachButton, textField, voiceButton, sendButton])
    }
    
    private func configureButton(_ button: UIButton, icon: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        button.setImage(UIImage(systemName: icon, withConfiguration: config), for: .normal)
        button.tintColor = Theme.Colors.accent
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let safeBottom = safeAreaInsets.bottom
        let panelHeight: CGFloat = 52
        
        glassBackground.frame = bounds
        
        let buttonSize: CGFloat = 44
        let sidePadding: CGFloat = 8
        
        // Attach Button
        attachButton.frame = CGRect(x: sidePadding, y: 4, width: buttonSize, height: buttonSize)
        
        // Voice / Send Button Logic
        let showSend = !(textField.text?.isEmpty ?? true)
        voiceButton.alpha = showSend ? 0 : 1
        sendButton.alpha = showSend ? 1 : 0
        sendButton.isHidden = !showSend
        voiceButton.isHidden = showSend
        
        let rightButtonX = bounds.width - buttonSize - sidePadding
        voiceButton.frame = CGRect(x: rightButtonX, y: 4, width: buttonSize, height: buttonSize)
        
        // Send Button is slightly smaller and circular
        let sendSize: CGFloat = 32
        sendButton.frame = CGRect(x: bounds.width - sendSize - 12, y: 4 + (buttonSize - sendSize)/2, width: sendSize, height: sendSize)
        
        // Text Field
        let tfX = attachButton.frame.maxX + 4
        let tfWidth = (showSend ? sendButton.frame.minX : voiceButton.frame.minX) - tfX - 8
        textField.frame = CGRect(x: tfX, y: 6, width: tfWidth, height: 40)
    }
    
    @objc private func textFieldDidChange() {
        UIView.animate(withDuration: 0.2) {
            self.setNeedsLayout()
        }
    }
    
    @objc private func didTapSend() {
        _ = textFieldShouldReturn(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        onSendMessage?(text)
        textField.text = ""
        textFieldDidChange()
        return true
    }
}
