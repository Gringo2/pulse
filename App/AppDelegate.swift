import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        
        // Use RootController as the application entry point
        // This coordinates the initial screen (ChatList)
        window?.rootViewController = RootController()
        window?.makeKeyAndVisible()
        
        // Initialize and connect to Tinode backend
        TinodeClient.shared.connect()
        TinodeClient.shared.handshake()
        
        return true
    }
}
