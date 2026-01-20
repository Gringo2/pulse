import UIKit

/// A node representing a single row in the chat list.
final class ChatListCellNode: Node {
    
    private let avatarContainer = UIView()
    private let avatarGradient = CAGradientLayer()
    private let avatarView = UIImageView()
    private let avatarBorder = UIView()
    
    private let nameLabel = UILabel()
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()
    private let separator = UIView()
    
    // Props
    var chat: Chat? {
        didSet {
            updateContent()
        }
    }
    
    private lazy var highlightAnimator = HighlightAnimator(view: self)
    
    override func setup() {
        backgroundColor = UIColor.white.withAlphaComponent(0.02)
        layer.cornerRadius = 50
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        clipsToBounds = true
        clipsToBounds = true
        
        // Avatar Container (Liquid effect)
        avatarContainer.clipsToBounds = false
        avatarContainer.layer.shadowColor = Theme.Colors.accent.cgColor
        avatarContainer.layer.shadowOpacity = 0.3
        avatarContainer.layer.shadowOffset = .zero
        avatarContainer.layer.shadowRadius = 8
        
        avatarGradient.cornerRadius = 24
        avatarGradient.startPoint = CGPoint(x: 0, y: 0)
        avatarGradient.endPoint = CGPoint(x: 1, y: 1)
        avatarGradient.colors = [Theme.Colors.accent.cgColor, UIColor(hex: "#00A2FF").cgColor]
        avatarContainer.layer.addSublayer(avatarGradient)
        
        avatarView.tintColor = .white
        avatarView.contentMode = .center
        avatarView.layer.cornerRadius = 24
        avatarView.layer.masksToBounds = true
        avatarView.backgroundColor = .clear
        
        avatarBorder.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        avatarBorder.layer.borderWidth = 1.0
        avatarBorder.layer.cornerRadius = 24
        avatarBorder.isUserInteractionEnabled = false
        
        // Typography matching Premium Showcase
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .white
        
        messageLabel.font = .systemFont(ofSize: 15, weight: .regular)
        messageLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        messageLabel.numberOfLines = 1
        
        timeLabel.font = .systemFont(ofSize: 13, weight: .regular)
        timeLabel.textColor = UIColor.white.withAlphaComponent(0.4)
        
        // Separator - Glassmorphic style
        separator.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        
        addSubnodes([avatarContainer, avatarView, avatarBorder, nameLabel, messageLabel, timeLabel, separator])
        
        self.isUserInteractionEnabled = true
    }
    
    private func updateContent() {
        guard let chat = chat else { return }
        nameLabel.text = chat.name
        messageLabel.text = chat.messagePreview
        timeLabel.text = chat.timeString
        
        if let avatar = chat.avatarName {
            avatarView.image = UIImage(systemName: avatar)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
        }
        
        // Randomize avatar gradient and shadow for variety in demo
        let hash = chat.name.hash
        let color1 = (hash % 2 == 0) ? Theme.Colors.accent : UIColor(hex: "#A259FF")
        let color2 = (hash % 2 == 0) ? UIColor(hex: "#00E0FF") : UIColor(hex: "#6B29FF")
        avatarGradient.colors = [color1.cgColor, color2.cgColor]
        avatarContainer.layer.shadowColor = color1.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horizontalPadding = Theme.Spacing.horizontalPadding
        let avatarSize: CGFloat = 48
        let avatarY = (bounds.height - avatarSize) / 2
        
        avatarContainer.frame = CGRect(x: horizontalPadding, y: avatarY, width: avatarSize, height: avatarSize)
        avatarGradient.frame = avatarContainer.bounds
        avatarView.frame = avatarContainer.frame
        avatarBorder.frame = avatarContainer.frame
        
        let textLeft = avatarView.frame.maxX + 14
        let textRightPadding: CGFloat = horizontalPadding
        
        // Time
        timeLabel.sizeToFit()
        let timeWidth = timeLabel.frame.width
        timeLabel.frame = CGRect(x: bounds.width - textRightPadding - timeWidth, y: 18, width: timeWidth, height: 18)
        
        // Name - Responsive width calculation
        let maxNameWidth = timeLabel.frame.minX - textLeft - 12
        nameLabel.frame = CGRect(x: textLeft, y: 18, width: maxNameWidth, height: 22)
        
        // Message - Responsive width calculation
        let messageWidth = bounds.width - textLeft - textRightPadding
        messageLabel.frame = CGRect(x: textLeft, y: nameLabel.frame.maxY + 2, width: messageWidth, height: 20)
        
        // Separator - Glassmorphic style
        separator.frame = CGRect(x: textLeft, y: bounds.height - 0.5, width: bounds.width - textLeft, height: 0.5)
    }
    
    // Touch Handling - Subtle glass highlight
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        highlightAnimator.animateHighlight(true)
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = UIColor.white.withAlphaComponent(0.06)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        highlightAnimator.animateHighlight(false)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor.white.withAlphaComponent(0.02)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        highlightAnimator.animateHighlight(false)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor.white.withAlphaComponent(0.02)
        }
    }
}
