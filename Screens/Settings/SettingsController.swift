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
        
        // Fetch Profile from Tinode
        TinodeClient.shared.subscribe(to: "me")
        TinodeClient.shared.onMeta = { [weak self] meta in
            guard meta.topic == "me", let desc = meta.desc else { return }
            
            // Parse 'public' vCard for FN (Full Name)
            if let publicData = try? JSONSerialization.jsonObject(with: desc.public) as? [String: Any],
               let fn = publicData["fn"] as? String {
                DispatchQueue.main.async {
                    self?.title = fn
                    // In a real app, we'd update a profile header node here
                }
            }
        }
    }
    
    @objc private func didTapPremium() {
        let premiumVC = PremiumController()
        premiumVC.modalPresentationStyle = .overFullScreen
        present(premiumVC, animated: true)
    }
}
