import UIKit

/// A node displaying a single message bubble.
/// Demonstrates:
/// - Custom constraints/layout for bubbles
/// - Highlight animation
/// - Tail drawing (simulated via layer or image)
final class MessageBubbleNode: Node {
    
    private let textLabel = UILabel()
    private let bubbleBackground = UIView()
    private let gradientLayer = CAGradientLayer()
    private let timeLabel = UILabel()
    
    var message: Message? {
        didSet {
            updateContent()
        }
    }
    
    private lazy var highlightAnimator = HighlightAnimator(view: bubbleBackground)
    
    override func setup() {
        // Bubble
        bubbleBackground.layer.cornerRadius = Theme.Spacing.bubbleRadius
        bubbleBackground.clipsToBounds = true
        
        // Gradient
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        bubbleBackground.layer.addSublayer(gradientLayer)
        
        // Text
        textLabel.numberOfLines = 0
        textLabel.font = .systemFont(ofSize: 17, weight: .regular)
        
        // Time
        timeLabel.font = .systemFont(ofSize: 11, weight: .medium)
        timeLabel.textAlignment = .right
        
        addSubnodes([bubbleBackground, textLabel, timeLabel])
        
        // Interactions
        isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.3
        addGestureRecognizer(longPress)
    }
    
    private func updateContent() {
        guard let message = message else { return }
        textLabel.text = message.text
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: message.timestamp)
        
        if message.isOutgoing {
            bubbleBackground.backgroundColor = .clear
            gradientLayer.isHidden = false
            gradientLayer.colors = Theme.Colors.bubbleOutgoing.map { $0.cgColor }
            textLabel.textColor = .white
            timeLabel.textColor = UIColor.white.withAlphaComponent(0.7)
            bubbleBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
            bubbleBackground.layer.borderWidth = 0
        } else {
            bubbleBackground.backgroundColor = Theme.Colors.glassBackground
            gradientLayer.isHidden = true
            textLabel.textColor = .white
            timeLabel.textColor = Theme.Colors.secondaryText
            bubbleBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            bubbleBackground.layer.borderColor = Theme.Colors.glassBorder.cgColor
            bubbleBackground.layer.borderWidth = 0.5
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maxBubbleWidth = bounds.width * 0.75
        let padding = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        
        let availableTextWidth = maxBubbleWidth - padding.left - padding.right
        let textSize = textLabel.sizeThatFits(CGSize(width: availableTextWidth, height: .greatestFiniteMagnitude))
        
        let bubbleWidth = max(textSize.width + padding.left + padding.right, 60)
        let bubbleHeight = textSize.height + padding.top + padding.bottom + 14
        
        let x: CGFloat = (message?.isOutgoing ?? true) ? (bounds.width - bubbleWidth - 12) : 12
        
        bubbleBackground.frame = CGRect(x: x, y: 4, width: bubbleWidth, height: bubbleHeight)
        gradientLayer.frame = bubbleBackground.bounds
        
        textLabel.frame = CGRect(x: x + padding.left, y: 4 + padding.top, width: textSize.width, height: textSize.height)
        timeLabel.frame = CGRect(x: x + bubbleWidth - 46 - padding.right, y: 4 + bubbleHeight - 20, width: 46, height: 14)
    }
    
    static func calculateHeight(for message: Message, width: CGFloat) -> CGFloat {
        let maxBubbleWidth = width * 0.75
        let padding = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        let constraintRect = CGSize(width: maxBubbleWidth - padding.left - padding.right, height: .greatestFiniteMagnitude)
        let boundingBox = message.text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 17)], context: nil)
        
        return ceil(boundingBox.height) + padding.top + padding.bottom + 14 + 10
    }
    
    // Interactions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        highlightAnimator.animateHighlight(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        highlightAnimator.animateHighlight(false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        highlightAnimator.animateHighlight(false)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.bubbleBackground.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            }) { _ in
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                    self.bubbleBackground.transform = .identity
                }, completion: nil)
            }
        }
    }
}
