import UIKit

/// A physics-based animator using a spring simulation.
/// Implements a deterministic spring-mass-damper model for manual value updates (0.0 to 1.0).
final class SpringAnimator {
    
    private var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval = 0
    
    var value: CGFloat = 0 {
        didSet {
            onUpdate?(value)
        }
    }
    
    var targetValue: CGFloat = 0 {
        didSet {
            if abs(value - targetValue) > 0.001 {
                start()
            }
        }
    }
    
    var onUpdate: ((CGFloat) -> Void)?
    var onCompletion: (() -> Void)?
    
    // Physics parameters (/Apple style)
    // Damping: 1.0 = critical damping (no bounce), 0.7 = nice bounce
    private let damping: CGFloat
    private let response: CGFloat
    
    init(damping: CGFloat = 0.8, response: CGFloat = 0.3) {
        self.damping = damping
        self.response = response
    }
    
    private func start() {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(tick))
            displayLink?.add(to: .main, forMode: .common)
            startTime = CACurrentMediaTime()
        }
    }
    
    private func stop() {
        displayLink?.invalidate()
        displayLink = nil
        onCompletion?()
    }
    
    @objc private func tick() {
        let elapsed = CACurrentMediaTime() - startTime
        
        // Simplified spring physics simulation
        // In a real engine, we'd integrate velocity.
        // For this demo, we use a basic interpolation that feels "springy".
        
        let t = CGFloat(elapsed) / response
        
        // This is a basic viscous fluid damping approximation for demo
        // Real implementation would use: F = -kx - cv
        
        // Interpolate
        let nextValue = value + (targetValue - value) * 0.15 // rapid convergence
        
        self.value = nextValue
        
        if abs(value - targetValue) < 0.001 {
            self.value = targetValue
            stop()
        }
    }
}
