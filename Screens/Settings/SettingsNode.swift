import UIKit

final class SettingsNode: Node {
    
    let glassContainer = GlassNode()
    let switchComponent = SwitchComponent()
    let sliderComponent = SliderComponent()
    
    private let switchLabel = UILabel()
    private let sliderLabel = UILabel()
    
    private let logoutCard = GlassNode()
    private let logoutLabel = UILabel()
    
    override func setup() {
        backgroundColor = Theme.Colors.background
        
        // Glass Container for items
        glassContainer.setBlurStyle(.systemUltraThinMaterialDark)
        
        // Labels
        switchLabel.text = "Liquid Switch"
        switchLabel.font = .systemFont(ofSize: 17, weight: .regular)
        switchLabel.textColor = .white
        
        sliderLabel.text = "Physics Slider"
        sliderLabel.font = .systemFont(ofSize: 17, weight: .regular)
        sliderLabel.textColor = .white
        
        // Logout Card
        logoutLabel.text = "Log Out"
        logoutLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        logoutLabel.textColor = .systemRed
        logoutLabel.textAlignment = .center
        
        addSubnodes([glassContainer, logoutCard])
        glassContainer.contentView.addSubnodes([switchLabel, switchComponent, sliderLabel, sliderComponent])
        logoutCard.contentView.addSubview(logoutLabel)
        
        // Config Components
        switchComponent.isOn = true
        sliderComponent.value = 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 16
        let itemHeight: CGFloat = 44
        
        // Container
        let containerHeight: CGFloat = 140
        glassContainer.frame = CGRect(x: padding, y: 120, width: bounds.width - (padding * 2), height: containerHeight)
        
        let innerPadding: CGFloat = 16
        let innerWidth = glassContainer.bounds.width - (innerPadding * 2)
        
        // Switch Row
        switchLabel.frame = CGRect(x: innerPadding, y: 20, width: 200, height: itemHeight)
        let switchWidth: CGFloat = 51
        let switchHeight: CGFloat = 31
        switchComponent.frame = CGRect(x: glassContainer.bounds.width - switchWidth - innerPadding, y: 20 + (itemHeight - switchHeight)/2, width: switchWidth, height: switchHeight)
        
        // Slider Row
        sliderLabel.frame = CGRect(x: innerPadding, y: switchLabel.frame.maxY + 10, width: 200, height: 20)
        sliderComponent.frame = CGRect(x: innerPadding, y: sliderLabel.frame.maxY + 10, width: innerWidth, height: 30)
        
        // Logout Card
        let logoutHeight: CGFloat = 54
        logoutCard.frame = CGRect(x: padding, y: glassContainer.frame.maxY + 20, width: bounds.width - (padding * 2), height: logoutHeight)
        logoutLabel.frame = logoutCard.contentView.bounds
    }
}
