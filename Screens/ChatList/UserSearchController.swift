import UIKit
import SwiftProtobuf // Needed for Pbx_TopicSub

final class UserSearchController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    // UI
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    // State
    private var results: [Pbx_TopicSub] = []
    var onSelectUser: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCallbacks()
    }
    
    private func setupUI() {
        title = "New Chat"
        view.backgroundColor = Theme.Colors.background
        
        // Search setup
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by Name or Email"
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = Theme.Colors.accent
        
        // TextField appearance hack
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white
            textField.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        // TableView setup
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.1)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        
        // Cancel button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
    }
    
    private func setupCallbacks() {
        TinodeClient.shared.onFindResult = { [weak self] users in
            guard let self = self else { return }
            self.results = users
            self.tableView.reloadData()
        }
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
    
    // MARK: - Search
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 2 else {
            results = []
            tableView.reloadData()
            return
        }
        
        // Debounce could be added here, but for now we search direct
        // Throttling at 0.5s is recommended in production
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(performSearch), with: text, afterDelay: 0.5)
    }
    
    @objc private func performSearch(_ text: String) {
        // Only search if text matched the input (sanity check not strictly needed with cancelPrevious)
        TinodeClient.shared.findUsers(query: text)
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let user = results[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        
        // Unpack public data (fn)
        var name = user.topic // user ID as fallback
        if let pubData = try? JSONSerialization.jsonObject(with: user.public) as? [String: Any],
           let fn = pubData["fn"] as? String {
            name = fn
        }
        
        config.text = name
        config.secondaryText = user.topic // User ID
        config.textProperties.color = .white
        config.secondaryTextProperties.color = Theme.Colors.secondaryText
        
        // Avatar placeholder
        config.image = UIImage(systemName: "person.circle.fill")
        config.imageProperties.tintColor = Theme.Colors.accent
        
        cell.contentConfiguration = config
        cell.backgroundColor = .clear
        
        // Selection view
        let bgView = UIView()
        bgView.backgroundColor = Theme.Colors.accent.withAlphaComponent(0.2)
        cell.selectedBackgroundView = bgView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = results[indexPath.row]
        onSelectUser?(user.topic) // Topic here is the User ID (e.g. "usrAlice")
        dismiss(animated: true)
    }
}
