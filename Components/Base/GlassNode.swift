import UIKit

/// A reusable node that provides a premium frosted-glass effect.
/// Uses UIVisualEffectView with support for light/dark blurs and vibrancy.
class GlassNode: Node {
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let vibrancyView = UIVisualEffectView()
    
    /// Inner container for vibrancy-affected content
    let contentView = UIView()
    
    override func setup() {
        backgroundColor = .clear
        
        // Setup blur and rounded appearance per Showcase spec
        blurView.clipsToBounds = true
        blurView.layer.masksToBounds = true
        
        // Vibrant secondary highlights
        vibrancyView.effect = UIVibrancyEffect(blurEffect: blurView.effect as! UIBlurEffect, style: .secondaryLabel)
        
        addSubview(blurView)
        blurView.contentView.addSubview(vibrancyView)
        blurView.contentView.addSubview(contentView)
        
        // Default glass styling
        layer.borderColor = Theme.Colors.glassBorder.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = Theme.Spacing.cardRadius
        blurView.layer.cornerRadius = Theme.Spacing.cardRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = bounds
        vibrancyView.frame = blurView.contentView.bounds
        contentView.frame = blurView.contentView.bounds
        
        // Dynamic border color update if needed for dark/light mode
        layer.borderColor = Theme.Colors.glassBorder.cgColor
    }
    
    /// Update intensity of the glass effect
    func setBlurStyle(_ style: UIBlurEffect.Style) {
        blurView.effect = UIBlurEffect(style: style)
    }
}
