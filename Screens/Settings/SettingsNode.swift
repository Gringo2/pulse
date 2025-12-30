import UIKit

final class SettingsNode: Node {
    
    let switchComponent = SwitchComponent()
    let sliderComponent = SliderComponent()
    
    private let switchLabel = UILabel()
    private let sliderLabel = UILabel()
    
    override func setup() {
        backgroundColor = .systemBackground
        
        // Labels
        switchLabel.text = "Liquid Switch"
        switchLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        sliderLabel.text = "Physics Slider"
        sliderLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        // Config Components
        switchComponent.isOn = true
        sliderComponent.value = 0.5
        
        addSubnodes([switchLabel, switchComponent, sliderLabel, sliderComponent])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 44
        
        // Switch Row
        switchLabel.frame = CGRect(x: padding, y: 120, width: 200, height: itemHeight)
        
        let switchWidth: CGFloat = 50
        let switchHeight: CGFloat = 30
        switchComponent.frame = CGRect(x: bounds.width - switchWidth - padding, y: 120 + (itemHeight - switchHeight)/2, width: switchWidth, height: switchHeight)
        
        // Slider Row
        sliderLabel.frame = CGRect(x: padding, y: switchLabel.frame.maxY + 30, width: 200, height: itemHeight)
        
        sliderComponent.frame = CGRect(x: padding, y: sliderLabel.frame.maxY + 10, width: bounds.width - (padding * 2), height: 44)
    }
}
