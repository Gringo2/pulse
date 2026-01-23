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
    let signUpButton = GlassButtonComponent(title: "Sign Up", iconName: "person.badge.plus")
    
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
        // Logo
        logoImageView.image = UIImage(named: "logo_high_res")
        // logoImageView.tintColor = Theme.Colors.accent // Disable tint for full color logo
        logoImageView.contentMode = .scaleAspectFit
        // logoImageView.addSymbolEffect(.pulse.byLayer)
        
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
        glassCard.contentView.addSubview(signUpButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        
        // Responsiveness: Use Theme spacing and dynamic heights
        let horizontalPadding = Theme.Spacing.horizontalPadding
        let maxCardWidth: CGFloat = 400
        let cardWidth = min(bounds.width - (horizontalPadding * 2), maxCardWidth)
        
        // Dynamic content height calculation
        let logoSize: CGFloat = 80
        let buttonHeight: CGFloat = 54
        let verticalSpacing: CGFloat = 20
        let bottomPadding: CGFloat = 40
        
        // Estimated content height: logo (80) + gap (20) + title (50) + gap (8) + subtitle (24) + gap (adaptive) + button (54) + bottom (40)
        let minContentHeight: CGFloat = 340
        let cardHeight = min(bounds.height - (safeAreaInsets.top + safeAreaInsets.bottom + 40), minContentHeight + 60)
        
        // Center the card
        glassCard.frame = CGRect(
            x: (bounds.width - cardWidth) / 2,
            y: (bounds.height - cardHeight) / 2,
            width: cardWidth,
            height: cardHeight
        )
        
        // Layout inside card - Content is centered within glassCard's contentView
        let contentWidth = cardWidth
        
        logoImageView.frame = CGRect(x: (contentWidth - logoSize)/2, y: 40, width: logoSize, height: logoSize)
        
        titleLabel.frame = CGRect(x: 0, y: logoImageView.frame.maxY + verticalSpacing, width: contentWidth, height: 50)
        subtitleLabel.frame = CGRect(x: 20, y: titleLabel.frame.maxY + 8, width: contentWidth - 40, height: 24)
        
        let buttonWidth = min(contentWidth - 60, 280)
        actionButton.frame = CGRect(
            x: (contentWidth - buttonWidth) / 2,
            y: cardHeight - (buttonHeight * 2) - bottomPadding - 10,
            width: buttonWidth,
            height: buttonHeight
        )
        
        signUpButton.frame = CGRect(
            x: (contentWidth - buttonWidth) / 2,
            y: actionButton.frame.maxY + 10,
            width: buttonWidth,
            height: buttonHeight
        )
    }
}
