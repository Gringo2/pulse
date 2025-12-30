import UIKit

/// Main node for the Chat List screen.
/// Passive Renderer: Receives State, Updates View.
final class ChatListNode: Node, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var chats: [Chat] = []
    
    // Output Events (Closures to Controller)
    var onSelectChat: ((Chat) -> Void)?
    
    override func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellWrapper.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 72
        tableView.separatorStyle = .none
        
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    // MARK: - State Update
    
    func update(state: ChatListState) {
        // Diffing could go here (Texture/IGListKit style)
        // For Pulse v1, simple reload
        self.chats = state.chats
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
    
    // Internal wrapper
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
