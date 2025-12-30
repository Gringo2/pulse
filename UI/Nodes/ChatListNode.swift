import UIKit

/// Main node for the Chat List screen.
/// Manages a ScrollView or TableView.
/// For "Pulse", we demonstrate a manual ScrollView managed node list to show "Performance Constraints" unless a TableView is needed.
/// However, effectively managing 1000+ items usually implies UITableView/UICollectionView.
/// The spec says: "MessageListNode... Smooth scrolling under load".
/// For ChatList, we will wrappers a UITableView for simplicity but wrapped in a Node structure.
final class ChatListNode: Node, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    var chats: [Chat] = []
    
    var onSelectChat: ((Chat) -> Void)?
    
    override func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellWrapper.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 72
        tableView.separatorStyle = .none // We draw our own
        
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    func update(chats: [Chat]) {
        self.chats = chats
        tableView.reloadData()
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellWrapper
        cell.node.chat = chats[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelectChat?(chats[indexPath.row])
    }
    
    // Internal wrapper to host Node inside UITableViewCell
    private class CellWrapper: UITableViewCell {
        let node = ChatListCellNode()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.addSubview(node)
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            node.frame = contentView.bounds
        }
    }
}
