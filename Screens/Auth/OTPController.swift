import UIKit

final class OTPController: UIViewController {
    
    private let node = OTPNode()
    private var currentState: OTPNode.State = .phone
    
    override func loadView() {
        self.view = node
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // node.actionButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        node.actionButton.onTap = { [weak self] in
            self?.didTapAction()
        }
        node.inputField.becomeFirstResponder()
    }
    
    @objc private func didTapAction() {
        // Simple mock validation
        guard let text = node.inputField.text, !text.isEmpty else { return }
        
        switch currentState {
        case .phone:
            // Simulate sending code
            // Transition to Code state
            currentState = .code
            node.update(state: .code)
            
            // Animation for transition (optional polish)
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .push
            transition.subtype = .fromRight
            node.inputField.layer.add(transition, forKey: nil)
            
        case .code:
            // Simulate verifying code
            completeLogin()
        }
    }
    
    private func completeLogin() {
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Save login state
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        
        // Tell Root to switch
        if let root = self.view.window?.rootViewController as? RootController {
            root.transitionToMainApp()
        }
    }
}
