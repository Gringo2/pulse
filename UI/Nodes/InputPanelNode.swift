import UIKit

/// The complex input panel of Pulse.
/// Features:
/// - Text Input
/// - Voice Mode Toggle
/// - Attachment Menu
/// - Glass styling
final class InputPanelNode: Node, UITextFieldDelegate {
    
    // UI Elements
    private let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    private let inputsContainer = UIView()
    private let textField = UITextField()
    private let voiceButton = UIButton(type: .system)
    private let attachButton = UIButton(type: .system)
    
    var onSendMessage: ((String) -> Void)?
    
    override func setup() {
        // Background
        backgroundView.layer.masksToBounds = true
        // Top border
        let border = UIView()
        border.backgroundColor = UIColor.separator
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        backgroundView.contentView.addSubview(border)
        
        // Buttons
        configureButton(attachButton, icon: "paperclip")
        configureButton(voiceButton, icon: "mic.fill")
        
        // Text Field
        textField.placeholder = "Message"
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 18
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        textField.leftViewMode = .always
        textField.delegate = self
        textField.returnKeyType = .send
        
        addSubnodes([backgroundView, attachButton, textField, voiceButton])
    }
    
    private func configureButton(_ button: UIButton, icon: String) {
        button.setImage(UIImage(systemName: icon), for: .normal)
        button.tintColor = .systemBlue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds
        
        let buttonSize: CGFloat = 44
        let padding: CGFloat = 8
        
        // Attach Button
        attachButton.frame = CGRect(x: 0, y: bounds.height - buttonSize - padding, width: buttonSize, height: buttonSize)
        
        // Voice Button
        voiceButton.frame = CGRect(x: bounds.width - buttonSize, y: bounds.height - buttonSize - padding, width: buttonSize, height: buttonSize)
        
        // Text Field
        let textFieldHeight: CGFloat = 36
        let textFieldY = bounds.height - textFieldHeight - ((bounds.height - textFieldHeight)/2) // centered vertically if single line
        // Actually, improved layout:
        let bottomOffset = buttonSize + padding
        let tfY = bounds.height - buttonSize - padding + (buttonSize - textFieldHeight)/2
        
        textField.frame = CGRect(
            x: attachButton.frame.maxX + 4,
            y: tfY,
            width: voiceButton.frame.minX - attachButton.frame.maxX - 8,
            height: textFieldHeight
        )
    }
    
    // Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        onSendMessage?(text)
        textField.text = ""
        return true
    }
}
