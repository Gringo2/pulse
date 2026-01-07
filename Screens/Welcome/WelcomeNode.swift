import UIKit

final class WelcomeNode: Node {
    
    // Background and Glass
    private let backgroundLayer = CAGradientLayer()
    private let glassCard = GlassNode()
    
    // Content
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    // Actions
    let actionButton = GlassButtonComponent(title: "Get Started", iconName: "arrow.right")
    
    override func setup() {
        backgroundColor = Theme.Colors.background
        
        // Dark Premium Background
        backgroundLayer.colors = [
            UIColor(hex: "#000000").cgColor,
            UIColor(hex: "#0A0A0A").cgColor,
            UIColor(hex: "#111111").cgColor
        ]
        backgroundLayer.locations = [0.0, 0.6, 1.0]
        layer.insertSublayer(backgroundLayer, at: 0)
        
        // Glass Card
        glassCard.setBlurStyle(.systemUltraThinMaterialDark)
        addSubview(glassCard)
        
        // Logo (System image for now, matching style)
        logoImageView.image = UIImage(systemName: "waveform.circle.fill")
        logoImageView.tintColor = Theme.Colors.accent
        logoImageView.contentMode = .scaleAspectFit
        // logoImageView.addSymbolEffect(.pulse.byLayer) // iOS 17 animation commented out due to build ambiguity
        
        // Text
        titleLabel.text = "Pulse"
        titleLabel.font = .systemFont(ofSize: 42, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "The Future of Connection"
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = Theme.Colors.secondaryText
        subtitleLabel.textAlignment = .center
        
        // Button
        // Configured in init
        
        // Hierarchy
        glassCard.contentView.addSubview(logoImageView)
        glassCard.contentView.addSubview(titleLabel)
        glassCard.contentView.addSubview(subtitleLabel)
        glassCard.contentView.addSubview(actionButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        
        let cardPadding: CGFloat = 24
        let cardWidth = bounds.width - (cardPadding * 2)
        let cardHeight: CGFloat = 400
        
        // Center the card
        glassCard.frame = CGRect(
            x: cardPadding,
            y: (bounds.height - cardHeight) / 2,
            width: cardWidth,
            height: cardHeight
        )
        
        // Layout inside card
        let contentWidth = cardWidth // Use calculated width directly
        
        let logoSize: CGFloat = 80
        logoImageView.frame = CGRect(x: (contentWidth - logoSize)/2, y: 60, width: logoSize, height: logoSize)
        
        titleLabel.frame = CGRect(x: 0, y: logoImageView.frame.maxY + 20, width: contentWidth, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 8, width: contentWidth, height: 24)
        
        let buttonHeight: CGFloat = 54
        let buttonWidth = contentWidth - 60
        actionButton.frame = CGRect(x: 30, y: cardHeight - buttonHeight - 40, width: buttonWidth, height: buttonHeight)
    }
}
