import UIKit

/// Base class for all UI nodes in Pulse.
/// Designed for a high-performance, unidirectional rendering architecture:
/// - Lightweight: Minimal overhead on top of UIView.
/// - Explicit layout: Enforces manual frame calculations for deterministic performance.
/// - Performance first: Optimized for high-frequency updates and smooth scrolling.
class Node: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /// Supports Node() instantiation Shortcut
    convenience init() {
        self.init(frame: .zero)
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
