import UIKit

final class ActiveCallNode: Node {
    
    // UI Elements
    private let backgroundImageView = UIImageView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    
    private let avatarContainer = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let statusLabel = UILabel()
    
    // Controls
    let muteButton = GlassButtonComponent(title: "", iconName: "mic.fill")
    let endButton = GlassButtonComponent(title: "", iconName: "phone.down.fill")
    let speakerButton = GlassButtonComponent(title: "", iconName: "speaker.wave.2.fill")
    
    private let controlsStack = UIStackView()
    
    // Animation layers
    private let pulseLayer = CALayer()
    
    override func setup() {
        backgroundColor = .black
        
        // Background (Blurred version of avatar or generic gradient)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(systemName: "person.circle.fill") // Placeholder
        backgroundImageView.tintColor = Theme.Colors.accent.withAlphaComponent(0.2)
        
        addSubnodes([backgroundImageView, blurView])
        
        // Avatar
        avatarContainer.backgroundColor = Theme.Colors.glassBackground
        avatarContainer.layer.cornerRadius = 80
        avatarContainer.layer.borderColor = Theme.Colors.glassBorder.cgColor
        avatarContainer.layer.borderWidth = 1
        
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.tintColor = .white
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 80
        avatarImageView.clipsToBounds = true
        
        avatarContainer.addSubview(avatarImageView)
        
        // Pulse Animation Layer
        pulseLayer.backgroundColor = Theme.Colors.accent.cgColor
        pulseLayer.cornerRadius = 80
        pulseLayer.opacity = 0
        avatarContainer.layer.insertSublayer(pulseLayer, at: 0)
        
        // Info
        nameLabel.font = .systemFont(ofSize: 34, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.text = "Pulse User"
        
        statusLabel.font = .systemFont(ofSize: 17, weight: .regular)
        statusLabel.textColor = Theme.Colors.secondaryText
        statusLabel.textAlignment = .center
        statusLabel.text = "Connecting..."
        
        // Controls
        controlsStack.axis = .horizontal
        controlsStack.distribution = .equalSpacing
        controlsStack.alignment = .center
        controlsStack.spacing = 40
        
        // Customize End Button
        endButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.8)
        
        controlsStack.addArrangedSubview(muteButton)
        controlsStack.addArrangedSubview(endButton)
        controlsStack.addArrangedSubview(speakerButton)
        
        addSubnodes([avatarContainer, nameLabel, statusLabel, controlsStack])
        
        startPulseAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.frame = bounds
        blurView.frame = bounds
        
        let centerX = bounds.midX
        let topPadding = safeAreaInsets.top + 40
        let bottomPadding = safeAreaInsets.bottom + 40
        
        // Avatar - Scale based on height
        let avatarSize: CGFloat = min(bounds.height * 0.2, 160)
        avatarContainer.frame = CGRect(x: centerX - avatarSize/2, y: topPadding, width: avatarSize, height: avatarSize)
        avatarContainer.layer.cornerRadius = avatarSize / 2
        avatarImageView.frame = avatarContainer.bounds
        avatarImageView.layer.cornerRadius = avatarSize / 2
        pulseLayer.frame = avatarContainer.bounds
        pulseLayer.cornerRadius = avatarSize / 2
        
        nameLabel.frame = CGRect(x: 20, y: avatarContainer.frame.maxY + 30, width: bounds.width - 40, height: 40)
        statusLabel.frame = CGRect(x: 20, y: nameLabel.frame.maxY + 8, width: bounds.width - 40, height: 24)
        
        let stackWidth: CGFloat = 280
        let stackHeight: CGFloat = 80
        controlsStack.frame = CGRect(x: (bounds.width - stackWidth)/2, y: bounds.height - bottomPadding - stackHeight, width: stackWidth, height: stackHeight)
    }
    
    private func startPulseAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.3
        animation.duration = 1.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 0.3
        opacityAnim.toValue = 0.0
        opacityAnim.duration = 1.5
        opacityAnim.autoreverses = true // Actually logic for 'radar' might differ but breathing is fine
        opacityAnim.repeatCount = .infinity
        
        pulseLayer.add(animation, forKey: "pulse")
        pulseLayer.add(opacityAnim, forKey: "fade")
    }
    
    func update(status: String) {
        statusLabel.text = status
    }
}
