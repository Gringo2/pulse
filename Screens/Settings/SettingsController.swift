import UIKit

final class SettingsController: UIViewController {
    
    private let settingsNode = SettingsNode()
    
    override func loadView() {
        self.view = settingsNode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Playground"
        
        // Callbacks
        settingsNode.switchComponent.onValueChanged = { isOn in
            print("Switch: \(isOn)")
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        
        settingsNode.sliderComponent.onValueChanged = { val in
            // print("Slider: \(val)") // Noisy log
        }
    }
}
