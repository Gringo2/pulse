import UIKit

/// A node that displays a typing indicator animation
final class TypingIndicatorNode: UIView {
    
    private let containerView = UIView()
    private let dotViews: [UIView] = (0..<3).map { _ in UIView() }
    private var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupViews() {
        // Container with bubble background
        containerView.backgroundColor = Theme.Colors.secondaryBackground
        containerView.layer.cornerRadius = 16
        addSubview(containerView)
        
        // Three animated dots
        for (index, dot) in dotViews.enumerated() {
            dot.backgroundColor = Theme.Colors.textSecondary
            dot.layer.cornerRadius = 4
            containerView.addSubview(dot)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bubbleWidth: CGFloat = 60
        let bubbleHeight: CGFloat = 36
        containerView.frame = CGRect(x: 12, y: 0, width: bubbleWidth, height: bubbleHeight)
        
        // Position dots horizontally
        let dotSize: CGFloat = 8
        let spacing: CGFloat = 6
        let totalWidth = (dotSize * 3) + (spacing * 2)
        let startX = (bubbleWidth - totalWidth) / 2
        let y = (bubbleHeight - dotSize) / 2
        
        for (index, dot) in dotViews.enumerated() {
            let x = startX + CGFloat(index) * (dotSize + spacing)
            dot.frame = CGRect(x: x, y: y, width: dotSize, height: dotSize)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 84, height: 36)
    }
    
    func startAnimating() {
        guard !isAnimating else { return }
        isAnimating = true
        
        for (index, dot) in dotViews.enumerated() {
            let delay = Double(index) * 0.15
            animateDot(dot, delay: delay)
        }
    }
    
    func stopAnimating() {
        isAnimating = false
        dotViews.forEach { $0.layer.removeAllAnimations() }
    }
    
    private func animateDot(_ dot: UIView, delay: Double) {
        UIView.animate(
            withDuration: 0.6,
            delay: delay,
            options: [.repeat, .autoreverse],
            animations: {
                dot.transform = CGAffineTransform(translationX: 0, y: -8)
            }
        )
    }
}
