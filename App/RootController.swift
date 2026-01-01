import UIKit

/// Top-level container that manages navigation and the floating glass tab bar.
final class RootController: UITabBarController {
    
    private let glassTabBar = GlassNode()
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupCustomTabBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupTabs() {
        let chats = UINavigationController(rootViewController: ChatListController())
        let calls = UINavigationController(rootViewController: UIViewController()) // Placeholder
        let settings = UINavigationController(rootViewController: SettingsController())
        
        // Hide native tab bars
        self.tabBar.isHidden = true
        
        self.viewControllers = [chats, calls, settings]
    }
    
    private func setupCustomTabBar() {
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
