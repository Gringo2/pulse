import UIKit

final class SettingsNode: Node {
    
    let glassContainer = GlassNode()
    let switchComponent = SwitchComponent()
    let sliderComponent = SliderComponent()
    
    private let switchLabel = UILabel()
    private let sliderLabel = UILabel()
    
    private let notificationsLabel = UILabel()
    private let notificationsSwitch = SwitchComponent()
    
    private let hapticsLabel = UILabel()
    private let hapticsSlider = SliderComponent()
    
    private let logoutCard = GlassNode()
    private let logoutLabel = UILabel()
    
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
        
        // Labels
        switchLabel.text = "Dark Theme"
        switchLabel.font = .systemFont(ofSize: 17, weight: .regular)
        switchLabel.textColor = .white
        
        sliderLabel.text = "Sound Effects"
        sliderLabel.font = .systemFont(ofSize: 17, weight: .regular)
        sliderLabel.textColor = .white
        
        notificationsLabel.text = "Notifications"
        notificationsLabel.font = .systemFont(ofSize: 17, weight: .semibold) // Using semi-bold to match SVG text style often seen
        notificationsLabel.textColor = .white
        
        hapticsLabel.text = "Haptics"
        hapticsLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        hapticsLabel.textColor = .white
        
        // Logout Card
        logoutLabel.text = "Log Out"
        logoutLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        logoutLabel.textColor = .systemRed
        logoutLabel.textAlignment = .center
        
        addSubnodes([glassContainer, logoutCard])
        addSubnodes([glassContainer, logoutCard])
        glassContainer.contentView.addSubnodes([
            switchLabel, switchComponent,
            notificationsLabel, notificationsSwitch,
            sliderLabel, sliderComponent,
            hapticsLabel, hapticsSlider
        ])
        logoutCard.contentView.addSubview(logoutLabel)
        
        // Config Components
        switchComponent.isOn = true
        notificationsSwitch.isOn = false
        sliderComponent.value = 0.5
        hapticsSlider.value = 0.8
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        
        let padding: CGFloat = 16
        let itemHeight: CGFloat = 44
        
        // Container - Increased height for 4 items
        let containerHeight: CGFloat = 280
        glassContainer.frame = CGRect(x: padding, y: 120, width: bounds.width - (padding * 2), height: containerHeight)
        
        let innerPadding: CGFloat = 16
        let innerWidth = glassContainer.bounds.width - (innerPadding * 2)
        
        // Dark Theme (Switch)
        switchLabel.frame = CGRect(x: innerPadding, y: 20, width: 200, height: itemHeight)
        let switchWidth: CGFloat = 51
        let switchHeight: CGFloat = 31
        switchComponent.frame = CGRect(x: glassContainer.bounds.width - switchWidth - innerPadding, y: 20 + (itemHeight - switchHeight)/2, width: switchWidth, height: switchHeight)
        
        // Notifications (Switch)
        let notifY = switchLabel.frame.maxY + 10
        notificationsLabel.frame = CGRect(x: innerPadding, y: notifY, width: 200, height: itemHeight)
        notificationsSwitch.frame = CGRect(x: glassContainer.bounds.width - switchWidth - innerPadding, y: notifY + (itemHeight - switchHeight)/2, width: switchWidth, height: switchHeight)
        
        // Sound Effects (Slider)
        let soundY = notificationsLabel.frame.maxY + 10
        sliderLabel.frame = CGRect(x: innerPadding, y: soundY, width: 200, height: 20)
        sliderComponent.frame = CGRect(x: innerPadding, y: sliderLabel.frame.maxY + 8, width: innerWidth, height: 30)
        
        // Haptics (Slider)
        let hapticsY = sliderComponent.frame.maxY + 16
        hapticsLabel.frame = CGRect(x: innerPadding, y: hapticsY, width: 200, height: 20)
        hapticsSlider.frame = CGRect(x: innerPadding, y: hapticsLabel.frame.maxY + 8, width: innerWidth, height: 30)
        
        // Logout Card
        let logoutHeight: CGFloat = 54
        logoutCard.frame = CGRect(x: padding, y: glassContainer.frame.maxY + 20, width: bounds.width - (padding * 2), height: logoutHeight)
        logoutLabel.frame = logoutCard.contentView.bounds
    }
}
