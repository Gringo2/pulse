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
    }
    
    private func handleUpgrade() {
        let alert = UIAlertController(title: "Premium", message: "Upgrade feature is mock-only.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
