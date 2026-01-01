import UIKit

/// A custom slider component.
/// Features:
/// - Smooth tracking
/// - Track scale animation on touch
final class SliderComponent: Node {
    
    var value: CGFloat = 0.0 {
        didSet {
            value = min(max(value, 0), 1)
            setNeedsLayout()
        }
    }
    
    var onValueChanged: ((CGFloat) -> Void)?
    
    private let trackView = UIView()
    private let fillView = UIView()
    private let knobView = UIView()
    
    // Animation
    private lazy var highlightAnimator = HighlightAnimator(view: knobView)
    
    override func setup() {
        trackView.backgroundColor = Theme.Colors.glassBackground
        trackView.layer.cornerRadius = 2
        trackView.layer.borderColor = Theme.Colors.glassBorder.cgColor
        trackView.layer.borderWidth = 0.5
        
        fillView.backgroundColor = Theme.Colors.accent
        fillView.layer.cornerRadius = 2
        
        knobView.backgroundColor = .white
        knobView.layer.shadowColor = UIColor.black.cgColor
        knobView.layer.shadowOpacity = 0.15
        knobView.layer.shadowOffset = CGSize(width: 0, height: 1)
        knobView.layer.shadowRadius = 3
        knobView.layer.cornerRadius = 14
        knobView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        knobView.layer.borderWidth = 0.5
        
        addSubnodes([trackView, fillView, knobView])
        
        // Pan Gesture
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(pan)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let trackHeight: CGFloat = 4
        let knobSize: CGFloat = 28
        
        trackView.frame = CGRect(x: 0, y: (bounds.height - trackHeight)/2, width: bounds.width, height: trackHeight)
        
        let fillWidth = bounds.width * value
        fillView.frame = CGRect(x: 0, y: (bounds.height - trackHeight)/2, width: fillWidth, height: trackHeight)
        
        let knobX = (bounds.width - knobSize) * value
        knobView.frame = CGRect(x: knobX, y: (bounds.height - knobSize)/2, width: knobSize, height: knobSize)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        let progress = location.x / bounds.width
        
        switch gesture.state {
        case .began:
            highlightAnimator.animateHighlight(true)
        case .changed:
            self.value = progress
            onValueChanged?(self.value)
        case .ended, .cancelled:
            highlightAnimator.animateHighlight(false)
        default:
            break
        }
    }
}
