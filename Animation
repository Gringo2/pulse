import UIKit

/// Manages the specific 40ms touch highlight animation
final class HighlightAnimator {
    
    private let view: UIView
    
    // Constraints
    private let highlightScale: CGFloat = 0.96
    private let duration: TimeInterval = 0.04 // 40ms constraint
    
    init(view: UIView) {
        self.view = view
    }
    
    func animateHighlight(_ highlighted: Bool) {
        let targetScale: CGFloat = highlighted ? highlightScale : 1.0
        
        // Layout thrashing avoidance: Use explicit transform animation
        // We use UIView.animate for simplicity here but with specific options
        // to ensure a non-blocking immediate update.
        
        let options: UIView.AnimationOptions = [.beginFromCurrentState, .allowUserInteraction, .curveEaseOut]
        
        UIView.animate(withDuration: highlighted ? duration : 0.2, // longer release
                       delay: 0,
                       options: options,
                       animations: {
            self.view.transform = CGAffineTransform(scaleX: targetScale, y: targetScale)
        }, completion: nil)
    }
}
