import UIKit

/// Top-level container that manages navigation and the floating glass tab bar.
final class RootController: UITabBarController {
    
    private let glassTabBar = GlassNode()
    private let stackView = UIStackView()
    
    // Track current flow
    private var isMainApp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = UserDefaults.standard.string(forKey: "tinode_token") {
            // Attempt auto-login with stored token
            let secret = Data(token.utf8)
            TinodeClient.shared.login(scheme: "token", secret: secret)
            
            startMainApp()
        } else {
            startOnboarding()
        }
    }
    
    private weak var onboardingFlow: UINavigationController?

    func transitionToMainApp() {
        // Find the onboarding nav
        guard let window = self.view.window else { return }
        
        // Cleanup Onboarding
        if let onboarding = onboardingFlow {
            onboarding.willMove(toParent: nil)
            onboarding.view.removeFromSuperview()
            onboarding.removeFromParent()
            self.onboardingFlow = nil
        }
        
        // Setup main app structure (in background)
        setupTabs()
        setupCustomTabBar()
        
        // Animate
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        window.layer.add(transition, forKey: kCATransition)
        
        // Switch
        self.selectedIndex = 0
        self.glassTabBar.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.glassTabBar.alpha = 1
        }
    }
    
    private func startOnboarding() {
        let welcome = WelcomeController()
        let nav = UINavigationController(rootViewController: welcome)
        nav.modalPresentationStyle = .fullScreen
        nav.setNavigationBarHidden(true, animated: false)
        
        // Present or Add as child
        addChild(nav)
        view.addSubview(nav.view)
        nav.view.frame = view.bounds
        nav.didMove(toParent: self)
        
        self.onboardingFlow = nav
    }
    
    private func startMainApp() {
        setupTabs()
        setupCustomTabBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupTabs() {
        // If we already have tabs, don't redo
        guard viewControllers == nil || viewControllers?.isEmpty == true else { return }
        
        let chats = UINavigationController(rootViewController: ChatListController())
        let calls = UINavigationController(rootViewController: CallsController())
        let settings = UINavigationController(rootViewController: SettingsController())
        
        // Hide native tab bars
        self.tabBar.isHidden = true
        
        self.viewControllers = [chats, calls, settings]
    }
    
    private func setupCustomTabBar() {
        if glassTabBar.superview != nil { return }
        
        glassTabBar.backgroundColor = .clear
        glassTabBar.setBlurStyle(.systemUltraThinMaterialDark)
        
        // Tab Buttons
        let icons = ["message.fill", "phone.fill", "gearshape.fill"]
        for (index, icon) in icons.enumerated() {
            let button = UIButton(type: .system)
            let image = UIImage(systemName: icon)?.withRenderingMode(.alwaysTemplate)
            button.setImage(image, for: .normal)
            button.tintColor = index == 0 ? Theme.Colors.accent : Theme.Colors.secondaryText
            button.tag = index
            button.addTarget(self, action: #selector(didSelectTab(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        stackView.distribution = .fillEqually
        glassTabBar.contentView.addSubview(stackView)
        view.addSubview(glassTabBar)
    }
    
    @objc private func didSelectTab(_ sender: UIButton) {
        self.selectedIndex = sender.tag
        stackView.arrangedSubviews.enumerated().forEach { index, view in
            view.tintColor = index == sender.tag ? Theme.Colors.accent : Theme.Colors.secondaryText
        }
        
        // Haptic feedback for premium feel
        let feedback = UISelectionFeedbackGenerator()
        feedback.selectionChanged()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let barWidth = view.bounds.width - (Theme.Spacing.horizontalPadding * 2)
        let barHeight: CGFloat = 64
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom > 0 ? view.safeAreaInsets.bottom : 20
        
        glassTabBar.frame = CGRect(
            x: Theme.Spacing.horizontalPadding,
            y: view.bounds.height - barHeight - bottomPadding,
            width: barWidth,
            height: barHeight
        )
        
        // Force layout update so glassTabBar.contentView has valid bounds
        glassTabBar.layoutIfNeeded()
        
        stackView.frame = glassTabBar.contentView.bounds
        
        // Ensure the selected tab content doesn't get covered (optional, or use contentInsets)
    }
}
