import UIKit

final class CallsController: UIViewController {
    
    private let node = CallsNode()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        self.view = node
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupNodeCallbacks()
        loadData()
    }
    
    private func setupNavigation() {
        title = "Calls"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = Theme.Colors.accent
    }
    
    private func setupNodeCallbacks() {
        node.onSelectCall = { [weak self] call in
            // Handle call selection
            let activeCall = ActiveCallController()
            activeCall.modalPresentationStyle = .overFullScreen
            activeCall.modalTransitionStyle = .crossDissolve
            self?.present(activeCall, animated: true)
        }
    }
    
    private func loadData() {
        // Simulate async load
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            let calls = Call.mockData()
            self?.node.update(calls: calls)
        }
    }
}
