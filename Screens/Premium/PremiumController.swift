import UIKit

final class PremiumController: UIViewController {
    
    private let node = PremiumNode()
    
    override func loadView() {
        self.view = node
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.onClose = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        node.upgradeButton.onTap = { [weak self] in
            self?.handleUpgrade()
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                view.frame.origin.y = translation.y
            }
        case .ended:
            if translation.y > 200 || velocity.y > 500 {
                dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = 0
                }
            }
        default:
            break
        }
    }
    
    private func handleUpgrade() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        let alert = UIAlertController(title: "Pulse Premium", message: "You are now a Pulse Premium member! ✨", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Awesome", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}
