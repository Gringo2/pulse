import UIKit

/// A reusable glass-style button component.
/// Demonstrates:
/// - VisualEffectView usage
/// - Highlight animation (HighlightAnimator)
/// - Component encapsulation
final class GlassButtonComponent: Node {
    
    private let blurView: UIVisualEffectView
    private let titleLabel: UILabel
    private let iconView: UIImageView
    
    // Animation engine
    private lazy var highlightAnimator = HighlightAnimator(view: self)
    
    var onTap: (() -> Void)?
    
    func setTitle(_ title: String) {
        titleLabel.text = title
        setNeedsLayout()
    }
    
    init(title: String, iconName: String? = nil) {
        let effect = UIBlurEffect(style: .systemThinMaterial)
        self.blurView = UIVisualEffectView(effect: effect)
        
        self.titleLabel = UILabel()
        self.titleLabel.text = title
        self.titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        self.titleLabel.textColor = .label
        self.titleLabel.textAlignment = .center
        
        self.iconView = UIImageView()
        if let iconName = iconName {
            self.iconView.image = UIImage(systemName: iconName)
        }
        self.iconView.tintColor = .label
        self.iconView.isHidden = iconName == nil
        
        super.init(frame: .zero)
        
        // Interaction
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        
        // Touch down handling would require a custom GestureRecognizer or UIControl subclassing
        // For simplicity in Node architecture, we often use touchesBegan/Ended if strictly UIView based
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        blurView.layer.cornerRadius = 12
        blurView.layer.masksToBounds = true
        blurView.isUserInteractionEnabled = false // Pass touches through to the Node
        
        addSubnodes([blurView, iconView, titleLabel])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = bounds
        
        // Center text and icon
        // Simple manual layout
        titleLabel.sizeToFit()
        
        if iconView.isHidden {
            titleLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        } else {
            // Layout with icon
            let spacing: CGFloat = 8
            let totalWidth = titleLabel.frame.width + 24 + spacing
            
            iconView.frame = CGRect(x: (bounds.width - totalWidth) / 2, y: (bounds.height - 24) / 2, width: 24, height: 24)
            titleLabel.frame.origin = CGPoint(x: iconView.frame.maxX + spacing, y: (bounds.height - titleLabel.frame.height) / 2)
        }
    }
    
    // MARK: - Interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        highlightAnimator.animateHighlight(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        highlightAnimator.animateHighlight(false)
        onTap?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        highlightAnimator.animateHighlight(false)
    }
    
    @objc private func handleTap() {
        // Redundant if using touchesEnded, but good for accessibility/standard gestures
        // Keeping logic in touchesEnded for the "press" physics feel
    }
}
