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
        settingsNode.fluidSwitch.onValueChanged = { isOn in
            print("Fluid: \(isOn)")
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        
        settingsNode.soundsSwitch.onValueChanged = { isOn in
            print("Sounds: \(isOn)")
        }
        
        settingsNode.vibrationSwitch.onValueChanged = { isOn in
            print("Vibration: \(isOn)")
        }
        
        // Premium Tap
        let premiumTap = UITapGestureRecognizer(target: self, action: #selector(didTapPremium))
        settingsNode.premiumCard.addGestureRecognizer(premiumTap)
    }
    
    @objc private func didTapPremium() {
        let premiumVC = PremiumController()
        premiumVC.modalPresentationStyle = .overFullScreen
        present(premiumVC, animated: true)
    }
}
