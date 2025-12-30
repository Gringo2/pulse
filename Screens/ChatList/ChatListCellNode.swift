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
        // Avatar
        avatarView.tintColor = .systemBlue
        avatarView.contentMode = .scaleAspectFit
        avatarView.layer.cornerRadius = 24
        avatarView.layer.masksToBounds = true
        avatarView.backgroundColor = .systemGray6
        
        // Labels
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        messageLabel.font = .systemFont(ofSize: 15, weight: .regular)
        messageLabel.textColor = .secondaryLabel
        timeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        timeLabel.textColor = .secondaryLabel
        
        // Separator
        separator.backgroundColor = .separator
        
        addSubnodes([avatarView, nameLabel, messageLabel, timeLabel, separator])
        
        // Interaction
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
        
        let padding: CGFloat = 12
        let avatarSize: CGFloat = 48
        
        avatarView.frame = CGRect(x: padding, y: (bounds.height - avatarSize)/2, width: avatarSize, height: avatarSize)
        
        let textLeft = avatarView.frame.maxX + 12
        let textRight = bounds.width - padding
        
        // Name
        nameLabel.frame = CGRect(x: textLeft, y: 10, width: textRight - textLeft - 50, height: 22)
        
        // Time
        timeLabel.sizeToFit()
        timeLabel.frame.origin = CGPoint(x: bounds.width - padding - timeLabel.frame.width, y: 12)
        
        // Message
        messageLabel.frame = CGRect(x: textLeft, y: nameLabel.frame.maxY + 2, width: textRight - textLeft, height: 20)
        
        // Separator
        separator.frame = CGRect(x: textLeft, y: bounds.height - 0.5, width: bounds.width - textLeft, height: 0.5)
    }
    
    // Touch Handling for immediate visual feedback.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        highlightAnimator.animateHighlight(true)
        self.backgroundColor = .systemGray6 // explicit tap color
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        highlightAnimator.animateHighlight(false)
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = .clear
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        highlightAnimator.animateHighlight(false)
        self.backgroundColor = .clear
    }
}
