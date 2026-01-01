import UIKit

/// A diagnostic debug overlay for monitoring real-time performance.
/// - Tracks FPS
/// - Tracks active node count (simulated)
final class PerformanceMonitor {
    
    static let shared = PerformanceMonitor()
    
    private var window: UIWindow?
    private let label = UILabel()
    private var displayLink: CADisplayLink?
    private var lastTime: CFTimeInterval = 0
    private var frameCount: Int = 0
    
    // Node tracking
    var activeNodeCount: Int = 0 {
        didSet {
            // In a real app, we'd debounce or only update on frame tick
        }
    }
    
    func clean() {
        displayLink?.invalidate()
        window?.isHidden = true
        window = nil
    }
    
    func start() {
        guard window == nil else { return }
        
        let w = UIWindow(frame: CGRect(x: 10, y: 50, width: 200, height: 60)) // Top left
        w.windowLevel = .alert + 1
        w.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        w.layer.cornerRadius = 8
        w.clipsToBounds = true
        w.isUserInteractionEnabled = false // Pass through
        
        label.frame = w.bounds
        label.textColor = .green
        label.font = .monospacedDigitSystemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        let vc = UIViewController()
        vc.view.addSubview(label)
        w.rootViewController = vc
        w.isHidden = false
        self.window = w
        
        // Timer
        let link = CADisplayLink(target: self, selector: #selector(tick))
        link.add(to: .main, forMode: .common)
        self.displayLink = link
    }
    
    @objc private func tick(link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        
        frameCount += 1
        let delta = link.timestamp - lastTime
        
        if delta >= 1.0 {
            let fps = Double(frameCount) / delta
            let roundedFPS = Int(round(fps))
            
            // Color coding
            if roundedFPS < 50 {
                label.textColor = .red
            } else if roundedFPS < 58 {
                label.textColor = .yellow
            } else {
                label.textColor = .green
            }
            
            label.text = "FPS: \(roundedFPS)\nNodes: ~\(activeNodeCount)"
            
            frameCount = 0
            lastTime = link.timestamp
        }
    }
}
