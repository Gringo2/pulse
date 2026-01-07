import UIKit

final class PremiumNode: Node {
    
    private let backgroundLayer = CAGradientLayer()
    private let glassCard = GlassNode()
    
    private let closeButton = UIButton(type: .system)
    
    private let crownIcon = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let featuresStack = UIStackView()
    
    let upgradeButton = GlassButtonComponent(title: "Join Pulse Premium", iconName: "star.fill")
    
    var onClose: (() -> Void)?
    
    override func setup() {
        backgroundColor = .black
        
        // Gold Gradient Background
        backgroundLayer.colors = [
            UIColor(hex: "#1a1a1a").cgColor,
            UIColor(hex: "#2a2200").cgColor, // Subtle gold tint
            UIColor(hex: "#000000").cgColor
        ]
        backgroundLayer.locations = [0.0, 0.5, 1.0]
        layer.insertSublayer(backgroundLayer, at: 0)
        
        // Glass Card
        glassCard.setBlurStyle(.systemUltraThinMaterialDark)
        addSubview(glassCard)
        
        // Close Button
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .white.withAlphaComponent(0.6)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        addSubview(closeButton)
        
        // Content
        crownIcon.image = UIImage(systemName: "crown.fill")
        crownIcon.tintColor = .systemYellow
        crownIcon.contentMode = .scaleAspectFit
        
        titleLabel.text = "Pulse Premium"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "Unlock the ultimate experience."
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = Theme.Colors.secondaryText
        subtitleLabel.textAlignment = .center
        
        // Features
        featuresStack.axis = .vertical
        featuresStack.spacing = 20
        featuresStack.alignment = .leading
        
        addFeature(text: "Unlimited Call Duration")
        addFeature(text: "High Fidelity Audio")
        addFeature(text: "Exclusive App Icons")
        addFeature(text: "Priority Support")
        
        // Hierarchy
        glassCard.contentView.addSubview(crownIcon)
        glassCard.contentView.addSubview(titleLabel)
        glassCard.contentView.addSubview(subtitleLabel)
        glassCard.contentView.addSubview(featuresStack)
        glassCard.contentView.addSubview(upgradeButton)
    }
    
    private func addFeature(text: String) {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 12
        row.alignment = .center
        
        let icon = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        icon.tintColor = Theme.Colors.accent
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        
        row.addArrangedSubview(icon)
        row.addArrangedSubview(label)
        
        featuresStack.addArrangedSubview(row)
    }
    
    @objc private func didTapClose() {
        onClose?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        
        let closeSize: CGFloat = 44
        closeButton.frame = CGRect(x: bounds.width - closeSize - 20, y: 50, width: closeSize, height: closeSize)
        
        let cardPadding: CGFloat = 20
        let cardHeight: CGFloat = 500
        let cardWidth = bounds.width - (cardPadding * 2)
        
        glassCard.frame = CGRect(x: cardPadding, y: (bounds.height - cardHeight) / 2, width: cardWidth, height: cardHeight)
        
        // Layout Content
        let contentWidth = cardWidth
        
        crownIcon.frame = CGRect(x: (contentWidth - 60)/2, y: 40, width: 60, height: 60)
        titleLabel.frame = CGRect(x: 0, y: crownIcon.frame.maxY + 16, width: contentWidth, height: 40)
        subtitleLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 4, width: contentWidth, height: 20)
        
        featuresStack.frame = CGRect(x: 40, y: subtitleLabel.frame.maxY + 40, width: contentWidth - 80, height: 160)
        
        upgradeButton.frame = CGRect(x: 20, y: cardHeight - 80, width: contentWidth - 40, height: 50)
    }
}
