import UIKit

/// A custom switch component with fluid physics.
/// Replicates the "Liquid Glass" feel with spring animations.
final class SwitchComponent: Node {
    
    var isOn: Bool = false {
        didSet {
            animateState()
        }
    }
    
    var onValueChanged: ((Bool) -> Void)?
    
    // UI
    private let trackView = UIView()
    private let knobView = UIView()
    private let iconView = UIImageView() // Optional icon inside knob
    
    // Physics
    private lazy var spring = SpringAnimator(damping: 0.7, response: 0.4)
    
    override func setup() {
        // Track
        trackView.backgroundColor = Theme.Colors.glassBackground
        trackView.layer.cornerRadius = 16
        trackView.layer.borderColor = Theme.Colors.glassBorder.cgColor
        trackView.layer.borderWidth = 0.5
        trackView.isUserInteractionEnabled = false
        
        // Knob
        knobView.backgroundColor = .white
        knobView.layer.shadowColor = UIColor.black.cgColor
        knobView.layer.shadowOpacity = 0.15
        knobView.layer.shadowOffset = CGSize(width: 0, height: 1)
        knobView.layer.shadowRadius = 3
        knobView.layer.cornerRadius = 14
        knobView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        knobView.layer.borderWidth = 0.5
        
        addSubnodes([trackView, knobView])
        
        // Wire up physics callback
        spring.onUpdate = { [weak self] progress in
            self?.updateLayout(progress: progress)
        }
        
        // Input
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggle))
        addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackView.frame = bounds
        trackView.layer.cornerRadius = bounds.height / 2
        knobView.layer.cornerRadius = (bounds.height - 4) / 2
        
        // Initial layout based on current spring value (0 or 1)
        updateLayout(progress: spring.value)
    }
    
    @objc private func toggle() {
        isOn.toggle()
        onValueChanged?(isOn)
    }
    
    private func animateState() {
        spring.targetValue = isOn ? 1.0 : 0.0
        
        // Color transition
        UIView.animate(withDuration: 0.3) {
            self.trackView.backgroundColor = self.isOn ? Theme.Colors.accent : Theme.Colors.glassBackground
            self.trackView.layer.borderColor = (self.isOn ? Theme.Colors.accent : Theme.Colors.glassBorder).cgColor
        }
    }
    
    private func updateLayout(progress: CGFloat) {
        let padding: CGFloat = 2
        let knobSize = bounds.height - (padding * 2)
        let travelDistance = bounds.width - knobSize - (padding * 2)
        
        let x = padding + (travelDistance * progress)
        knobView.frame = CGRect(x: x, y: padding, width: knobSize, height: knobSize)
    }
}
