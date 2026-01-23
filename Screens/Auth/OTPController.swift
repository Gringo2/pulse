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
            // Request OTP via Tinode {acc scheme="code"}
            let secret = Data(text.utf8)
            TinodeClient.shared.login(scheme: "code", secret: secret)
            
            // Transition to Code state
            currentState = .code
            node.update(state: .code)
            
            // Animation for transition
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .push
            transition.subtype = .fromRight
            node.inputField.layer.add(transition, forKey: nil)
            
        case .code:
            // Verify OTP via Tinode {login scheme="code"}
            let secret = Data(text.utf8)
            TinodeClient.shared.login(scheme: "code", secret: secret)
            
            // Observe the result via callback
            TinodeClient.shared.onCtrl = { [weak self] ctrl in
                if ctrl.code == 200 {
                    self?.completeLogin()
                } else {
                    // Handle error (e.g., show "Invalid Code")
                    print("Auth error: \(ctrl.text)")
                }
            }
        }
    }
    
    private func completeLogin() {
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Save login state
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        
        // Save persistent token
        if let token = TinodeClient.shared.sessionToken {
            UserDefaults.standard.set(token, forKey: "tinode_token")
        }
        
        // Tell Root to switch
        if let root = self.view.window?.rootViewController as? RootController {
            root.transitionToMainApp()
        }
    }
}
