import UIKit

/// Top-level container that manages navigation or tab switching.
final class RootController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        // Initialize the app with the primary conversation list.
        let chatListController = ChatListController()
        self.pushViewController(chatListController, animated: false)
    }
}
