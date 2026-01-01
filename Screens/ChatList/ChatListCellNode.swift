import UIKit

/// A node representing a single row in the chat list.
final class ChatListCellNode: Node {
    
    private let avatarView = UIImageView()
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
        backgroundColor = .clear
        
        // Avatar
        avatarView.tintColor = Theme.Colors.accent
        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.cornerRadius = 24
        avatarView.layer.masksToBounds = true
        avatarView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        
        // Typography matching Premium Showcase
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .white
        
        messageLabel.font = .systemFont(ofSize: 15, weight: .regular)
        messageLabel.textColor = Theme.Colors.secondaryText
        
        timeLabel.font = .systemFont(ofSize: 13, weight: .medium)
        timeLabel.textColor = Theme.Colors.secondaryText
        
        // Separator - Glassmorphic style
        separator.backgroundColor = Theme.Colors.glassBorder
        
        addSubnodes([avatarView, nameLabel, messageLabel, timeLabel, separator])
        
        self.isUserInteractionEnabled = true
    }
    
    private func updateContent() {
        guard let chat = chat else { return }
        nameLabel.text = chat.name
        messageLabel.text = chat.messagePreview
        timeLabel.text = chat.timeString
        if let avatar = chat.avatarName {
            avatarView.image = UIImage(systemName: avatar)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horizontalPadding = Theme.Spacing.horizontalPadding
        let avatarSize: CGFloat = 48
        
        avatarView.frame = CGRect(x: horizontalPadding, y: (bounds.height - avatarSize)/2, width: avatarSize, height: avatarSize)
        
        let textLeft = avatarView.frame.maxX + 12
        let textRight = bounds.width - horizontalPadding
        
        // Name
        nameLabel.frame = CGRect(x: textLeft, y: 14, width: textRight - textLeft - 60, height: 22)
        
        // Time
        timeLabel.sizeToFit()
        timeLabel.frame.origin = CGPoint(x: bounds.width - horizontalPadding - timeLabel.frame.width, y: 16)
        
        // Message
        messageLabel.frame = CGRect(x: textLeft, y: nameLabel.frame.maxY + 2, width: textRight - textLeft, height: 20)
        
        // Separator - Minimal footprint
        separator.frame = CGRect(x: textLeft, y: bounds.height - 0.5, width: bounds.width - textLeft - horizontalPadding, height: 0.5)
    }
    
    // Touch Handling - Subtle glass highlight
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        highlightAnimator.animateHighlight(true)
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        highlightAnimator.animateHighlight(false)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = .clear
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        highlightAnimator.animateHighlight(false)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = .clear
        }
    }
}
