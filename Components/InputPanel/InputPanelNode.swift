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
        // Glass Background (Floating Pill)
        glassBackground.layer.cornerRadius = 28
        glassBackground.layer.cornerCurve = .continuous
        glassBackground.layer.borderWidth = 0.5
        glassBackground.layer.borderColor = UIColor.white.withAlphaComponent(0.18).cgColor
        glassBackground.setBlurStyle(.systemUltraThinMaterialDark)
        glassBackground.clipsToBounds = true
        
        // Remove old top border
        // let topBorder = UIView() ...
        
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
        let panelHeight: CGFloat = 56 // Matches SVG height
        
        // Floating Layout
        let horizontalPadding: CGFloat = 32
        let verticalPadding: CGFloat = 8
        
        // Calculate frame for the pill
        // It should be centered horizontally, and positioned inside the bounds
        let pillWidth = bounds.width - (horizontalPadding * 2)
        
        glassBackground.frame = CGRect(x: horizontalPadding, y: verticalPadding, width: pillWidth, height: panelHeight)
        
        let buttonSize: CGFloat = 44
        let sidePadding: CGFloat = 8
        
        // Voice / Send Button Logic (Restored)
        let showSend = !(textField.text?.isEmpty ?? true)
        voiceButton.alpha = showSend ? 0 : 1
        sendButton.alpha = showSend ? 1 : 0
        sendButton.isHidden = !showSend
        voiceButton.isHidden = showSend
        
        let sendSize: CGFloat = 32
        
        let pillFrame = glassBackground.frame
        
        // Attach Button
        attachButton.frame = CGRect(x: pillFrame.minX + sidePadding, y: pillFrame.minY + 6, width: buttonSize, height: buttonSize)
        
        // Voice Button
        let rightButtonX = pillFrame.maxX - buttonSize - sidePadding
        voiceButton.frame = CGRect(x: rightButtonX, y: pillFrame.minY + 6, width: buttonSize, height: buttonSize)
        
        // Send Button
        sendButton.frame = CGRect(x: pillFrame.maxX - sendSize - 12, y: pillFrame.minY + 6 + (buttonSize - sendSize)/2, width: sendSize, height: sendSize)
        
        // Text Field
        // Update styling for transparency inside the glass
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 0
        
        let tfX = attachButton.frame.maxX + 4
        let tfWidth = (showSend ? sendButton.frame.minX : voiceButton.frame.minX) - tfX - 8
        let tfHeight: CGFloat = 40
        textField.frame = CGRect(x: tfX, y: pillFrame.minY + (panelHeight - tfHeight)/2, width: tfWidth, height: tfHeight)
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
