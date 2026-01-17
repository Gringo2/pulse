import UIKit

final class SettingsController: UIViewController {
    
    private let settingsNode = SettingsNode()
    
    override func loadView() {
        self.view = settingsNode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        
        // Load initial state
        settingsNode.fluidSwitch.isOn = SettingsManager.shared.isFluidEnabled
        settingsNode.soundsSwitch.isOn = SettingsManager.shared.isSoundsEnabled
        settingsNode.vibrationSwitch.isOn = SettingsManager.shared.isVibrationEnabled
        
        // Callbacks
        settingsNode.fluidSwitch.onValueChanged = { isOn in
            SettingsManager.shared.isFluidEnabled = isOn
            if isOn {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        }
        
        settingsNode.soundsSwitch.onValueChanged = { isOn in
            SettingsManager.shared.isSoundsEnabled = isOn
        }
        
        settingsNode.vibrationSwitch.onValueChanged = { isOn in
            SettingsManager.shared.isVibrationEnabled = isOn
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
