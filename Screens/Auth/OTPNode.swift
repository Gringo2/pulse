import UIKit

final class OTPNode: Node {
    
    enum State {
        case phone
        case code
    }
    
    // UI Elements
    private let backgroundLayer = CAGradientLayer()
    private let glassCard = GlassNode()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    // Inputs (Using UITextField directly for now, wrapping in glass later if needed)
    let inputField = UITextField()
    private let inputUnderline = UIView()
    
    // Actions
    let actionButton = GlassButtonComponent(title: "Send Code", iconName: "arrow.right")
    
    override func setup() {
        backgroundColor = Theme.Colors.background
        
        // Background
        backgroundLayer.colors = [
            UIColor(hex: "#050505").cgColor,
            UIColor(hex: "#121424").cgColor,
            UIColor(hex: "#050505").cgColor
        ]
        backgroundLayer.locations = [0.0, 0.4, 1.0]
        layer.insertSublayer(backgroundLayer, at: 0)
        
        // Glass Utility
        glassCard.setBlurStyle(.systemUltraThinMaterialDark)
        addSubview(glassCard)
        
        // Text
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = Theme.Colors.secondaryText
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        // Input
        inputField.font = .systemFont(ofSize: 24, weight: .semibold)
        inputField.textColor = .white
        inputField.textAlignment = .center
        inputField.keyboardType = .phonePad
        inputField.tintColor = Theme.Colors.accent
        
        inputUnderline.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        // Button

        
        glassCard.contentView.addSubnodes([titleLabel, subtitleLabel, inputField, inputUnderline, actionButton])
        
        update(state: .phone)
    }
    
    func update(state: State) {
        switch state {
        case .phone:
            titleLabel.text = "Your Phone"
            subtitleLabel.text = "We'll send you a secure code to log in."
            inputField.placeholder = "+1 555 000 0000"
            inputField.attributedPlaceholder = NSAttributedString(
                string: "+1 555 000 0000",
                attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.2)]
            )
            actionButton.setTitle("Send Code")
            
        case .code:
            titleLabel.text = "Verify Code"
            subtitleLabel.text = "Check your messages for the code."
            inputField.text = ""
            inputField.placeholder = "000000"
            inputField.attributedPlaceholder = NSAttributedString(
                string: "000000",
                attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.2)]
            )
            actionButton.setTitle("Start Pulse")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        
        let cardPadding: CGFloat = 24
        let cardWidth = bounds.width - (cardPadding * 2)
        let cardHeight: CGFloat = 320
        
        // Center vertically but slightly higher for keyboard
        glassCard.frame = CGRect(
            x: cardPadding,
            y: (bounds.height - cardHeight) / 2 - 40,
            width: cardWidth,
            height: cardHeight
        )
        
        let contentWidth = cardWidth // Use calculated width directly
        
        titleLabel.frame = CGRect(x: 0, y: 40, width: contentWidth, height: 34)
        subtitleLabel.frame = CGRect(x: 20, y: titleLabel.frame.maxY + 8, width: contentWidth - 40, height: 40)
        
        let inputWidth = contentWidth - 60
        inputField.frame = CGRect(x: 30, y: subtitleLabel.frame.maxY + 30, width: inputWidth, height: 44)
        inputUnderline.frame = CGRect(x: 30, y: inputField.frame.maxY + 2, width: inputWidth, height: 1)
        
        let buttonHeight: CGFloat = 54
        actionButton.frame = CGRect(x: 30, y: cardHeight - buttonHeight - 30, width: inputWidth, height: buttonHeight)
    }
}
