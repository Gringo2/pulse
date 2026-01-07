import UIKit

final class SettingsNode: Node {
    
    let glassContainer = GlassNode()
    private let fluidLabel = UILabel()
    let fluidSwitch = SwitchComponent()
    
    private let soundsLabel = UILabel()
    let soundsSwitch = SwitchComponent()
    
    private let vibrationLabel = UILabel()
    let vibrationSwitch = SwitchComponent()
    
    private let notifLabel = UILabel()
    private let notifValue = UILabel()
    
    private let appearanceLabel = UILabel()
    private let appearanceValue = UILabel()
    
    private let logoutCard = GlassNode()
    private let logoutLabel = UILabel()
    
    let premiumCard = GlassNode()
    private let premiumLabel = UILabel()
    
    private let backgroundLayer = CAGradientLayer()
    
    override func setup() {
        backgroundColor = Theme.Colors.background
        
        // Vibrant background gradient
        backgroundLayer.colors = [
            UIColor(hex: "#050505").cgColor,
            UIColor(hex: "#121424").cgColor,
            UIColor(hex: "#050505").cgColor
        ]
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        backgroundLayer.locations = [0.0, 0.4, 1.0]
        layer.insertSublayer(backgroundLayer, at: 0)
        
        // Glass Container for items
        glassContainer.setBlurStyle(.systemUltraThinMaterialDark)
        
        // Fluid Toggle
        fluidLabel.text = "Fluid Toggle"
        fluidLabel.font = .systemFont(ofSize: 17, weight: .regular)
        fluidLabel.textColor = .white
        
        // In-App Sounds
        soundsLabel.text = "In-App Sounds"
        soundsLabel.font = .systemFont(ofSize: 17, weight: .regular)
        soundsLabel.textColor = .white
        
        // Vibration
        vibrationLabel.text = "Vibration"
        vibrationLabel.font = .systemFont(ofSize: 17, weight: .regular)
        vibrationLabel.textColor = .white
        
        // Notification Sound
        notifLabel.text = "Notification Sound"
        notifLabel.font = .systemFont(ofSize: 17, weight: .regular)
        notifLabel.textColor = .white
        
        notifValue.text = "Default >"
        notifValue.font = .systemFont(ofSize: 15, weight: .regular)
        notifValue.textColor = UIColor.white.withAlphaComponent(0.5)
        notifValue.textAlignment = .right
        
        // Appearance
        appearanceLabel.text = "Appearance"
        appearanceLabel.font = .systemFont(ofSize: 17, weight: .regular)
        appearanceLabel.textColor = .white
        
        appearanceValue.text = ">"
        appearanceValue.font = .systemFont(ofSize: 17, weight: .regular)
        appearanceValue.textColor = UIColor.white.withAlphaComponent(0.5)
        appearanceValue.textAlignment = .right
        
        // Logout Card
        logoutLabel.text = "Log Out"
        logoutLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        logoutLabel.textColor = .systemRed
        logoutLabel.textAlignment = .center
        
        // Premium Card
        premiumCard.setBlurStyle(.systemThinMaterial) // Slightly lighter/gold?
        premiumLabel.text = "✨ Upgrade to Premium"
        premiumLabel.font = .systemFont(ofSize: 17, weight: .bold)
        premiumLabel.textColor = .systemYellow
        premiumLabel.textAlignment = .center
        
        addSubnodes([premiumCard, glassContainer, logoutCard])
        glassContainer.contentView.addSubnodes([
            fluidLabel, fluidSwitch,
            soundsLabel, soundsSwitch,
            vibrationLabel, vibrationSwitch,
            notifLabel, notifValue,
            appearanceLabel, appearanceValue
        ])
        logoutCard.contentView.addSubview(logoutLabel)
        premiumCard.contentView.addSubview(premiumLabel)
        
        // Config Components
        fluidSwitch.isOn = true
        soundsSwitch.isOn = true
        vibrationSwitch.isOn = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        
        let padding: CGFloat = 16
        let itemHeight: CGFloat = 44
        
        // Container - Increased height for 4 items
        // Container - Height for 5 items
        let containerHeight: CGFloat = 280
        // Premium Card
        let premiumHeight: CGFloat = 60
        premiumCard.frame = CGRect(x: padding, y: 120, width: bounds.width - (padding * 2), height: premiumHeight)
        premiumLabel.frame = CGRect(x: 20, y: 0, width: premiumCard.bounds.width - 40, height: premiumHeight)
        
        let containerY: CGFloat = premiumCard.frame.maxY + 20
        glassContainer.frame = CGRect(x: padding, y: containerY, width: bounds.width - (padding * 2), height: containerHeight)
        
        let innerPadding: CGFloat = 16
        let switchWidth: CGFloat = 51
        let switchHeight: CGFloat = 31
        
        // 1. Fluid Toggle
        fluidLabel.frame = CGRect(x: innerPadding, y: 20, width: 200, height: itemHeight)
        fluidSwitch.frame = CGRect(x: glassContainer.bounds.width - switchWidth - innerPadding, y: 20 + (itemHeight - switchHeight)/2, width: switchWidth, height: switchHeight)
        
        // 2. In-App Sounds
        let soundsY = fluidLabel.frame.maxY + 8
        soundsLabel.frame = CGRect(x: innerPadding, y: soundsY, width: 200, height: itemHeight)
        soundsSwitch.frame = CGRect(x: glassContainer.bounds.width - switchWidth - innerPadding, y: soundsY + (itemHeight - switchHeight)/2, width: switchWidth, height: switchHeight)
        
        // 3. Vibration
        let vibY = soundsLabel.frame.maxY + 8
        vibrationLabel.frame = CGRect(x: innerPadding, y: vibY, width: 200, height: itemHeight)
        vibrationSwitch.frame = CGRect(x: glassContainer.bounds.width - switchWidth - innerPadding, y: vibY + (itemHeight - switchHeight)/2, width: switchWidth, height: switchHeight)
        
        // 4. Notification Sound
        let notifY = vibrationLabel.frame.maxY + 8
        notifLabel.frame = CGRect(x: innerPadding, y: notifY, width: 200, height: itemHeight)
        notifValue.frame = CGRect(x: glassContainer.bounds.width - 120 - innerPadding, y: notifY, width: 120, height: itemHeight)
        
        // 5. Appearance
        let appY = notifLabel.frame.maxY + 8
        appearanceLabel.frame = CGRect(x: innerPadding, y: appY, width: 200, height: itemHeight)
        appearanceValue.frame = CGRect(x: glassContainer.bounds.width - 40 - innerPadding, y: appY, width: 40, height: itemHeight)
        
        let logoutHeight: CGFloat = 54
        logoutCard.frame = CGRect(x: padding, y: glassContainer.frame.maxY + 20, width: bounds.width - (padding * 2), height: logoutHeight)
        logoutLabel.frame = logoutCard.contentView.bounds
    }
}
