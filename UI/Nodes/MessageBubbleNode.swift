import UIKit

/// A node displaying a single message bubble.
/// Demonstrates:
/// - Custom constraints/layout for bubbles
/// - Highlight animation
/// - Tail drawing (simulated via layer or image)
final class MessageBubbleNode: Node {
    
    private let textLabel = UILabel()
    private let bubbleBackground = UIView()
    private let timeLabel = UILabel()
    
    var message: Message? {
        didSet {
            updateContent()
        }
    }
    
    private lazy var highlightAnimator = HighlightAnimator(view: bubbleBackground)
    
    override func setup() {
        // Bubble
        bubbleBackground.layer.cornerRadius = 16
        // To simulate a "tail", usually we'd use a CAShapeLayer or a specific corner radius config
        // For Pulse v1, we used varying corner radii
        
        // Text
        textLabel.numberOfLines = 0
        textLabel.font = .systemFont(ofSize: 16)
        
        // Time
        timeLabel.font = .systemFont(ofSize: 11)
        timeLabel.textColor = UIColor(white: 1, alpha: 0.7)
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
            bubbleBackground.backgroundColor = .systemBlue
            textLabel.textColor = .white
            bubbleBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        } else {
            bubbleBackground.backgroundColor = .systemGray5
            textLabel.textColor = .label
            timeLabel.textColor = .secondaryLabel
            bubbleBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Manual Layout for Bubble
        // 1. Measure text
        let maxBubbleWidth = bounds.width * 0.75
        let padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        let availableTextWidth = maxBubbleWidth - padding.left - padding.right
        let textSize = textLabel.sizeThatFits(CGSize(width: availableTextWidth, height: .greatestFiniteMagnitude))
        
        let bubbleWidth = textSize.width + padding.left + padding.right
        let bubbleHeight = textSize.height + padding.top + padding.bottom + 12 // extra space for time
        
        // Position
        let x: CGFloat
        if let msg = message, msg.isOutgoing {
            x = bounds.width - bubbleWidth - 10
        } else {
            x = 10
        }
        
        bubbleBackground.frame = CGRect(x: x, y: 4, width: bubbleWidth, height: bubbleHeight)
        
        textLabel.frame = CGRect(x: x + padding.left, y: 4 + padding.top, width: textSize.width, height: textSize.height)
        
        timeLabel.frame = CGRect(x: x + bubbleWidth - 40 - padding.right, y: 4 + bubbleHeight - 18, width: 40, height: 12)
    }
    
    // Size Calc helper for the List
    static func calculateHeight(for message: Message, width: CGFloat) -> CGFloat {
        // Simplified height calc
        // Real implementation would reuse layout logic
        let maxBubbleWidth = width * 0.75
        let padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        let constraintRect = CGSize(width: maxBubbleWidth - padding.left - padding.right, height: .greatestFiniteMagnitude)
        let boundingBox = message.text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height + padding.top + padding.bottom + 12 + 8 // +8 margin
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
            // Context Menu Trigger (Mock)
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.bubbleBackground.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                    self.bubbleBackground.transform = .identity
                }, completion: nil)
            }
        }
    }
}
