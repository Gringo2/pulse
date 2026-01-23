import UIKit

final class WelcomeController: UIViewController {
    
    private let node = WelcomeNode()
    
    override func loadView() {
        self.view = node
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // node.actionButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        node.actionButton.onTap = { [weak self] in
            self?.didTapStart()
        }
        
        node.signUpButton.onTap = { [weak self] in
            let registration = RegistrationController()
            let nav = UINavigationController(rootViewController: registration)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true)
        }
    }
    
    @objc private func didTapStart() {
        let otpController = OTPController()
        navigationController?.pushViewController(otpController, animated: true)
    }
}
