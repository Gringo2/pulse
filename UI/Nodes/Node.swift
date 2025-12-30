import UIKit

/// Base class for all UI nodes in Pulse.
/// Mimics AsyncDisplayKit's ASDisplayNode philosophy:
/// - Lightweight
/// - Explicit layout
/// - Performance first
class Node: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented - Pulse architecture requires code-based UI")
    }
    
    func setup() {
        // Override point for subclass customization
        // No auto-layout constraints by default; we favor manual layout for performance (per spec)
    }
    
    /// Called to update the layout of subnodes.
    /// In a real engine, this might happen on a background thread.
    /// Here we enforce manual layout discipline.
    override func layoutSubviews() {
        super.layoutSubviews()
        // Subclasses should implement their specific layout logic here
    }
    
    // Helper to add multiple subnodes
    func addSubnodes(_ nodes: [UIView]) {
        nodes.forEach { addSubview($0) }
    }
}
