import UIKit

final class ProfileController: UIViewController {
    
    private let node = ProfileNode()
    
    override func loadView() {
        self.view = node
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        setupNavigation()
    }
    
    private func setupNavigation() {
        // Transparent Nav Bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = Theme.Colors.accent
    }
}
