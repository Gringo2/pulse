import UIKit

/// Main node for the Chat List screen.
/// Passive Renderer: Receives State, Updates View.
final class ChatListNode: Node, UITableViewDelegate, UITableViewDataSource {
    
    private let backgroundLayer = CAGradientLayer()
    private let tableView = UITableView()
    private var chats: [Chat] = []
    
    // Output Events (Closures to Controller)
    var onSelectChat: ((Chat) -> Void)?
    
    override func setup() {
        backgroundColor = Theme.Colors.background
        
        // Vibrant background gradient to make glass pop
        backgroundLayer.colors = [
            UIColor(hex: "#050505").cgColor,
            UIColor(hex: "#121424").cgColor,
            UIColor(hex: "#050505").cgColor
        ]
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 1, y: 1)
        backgroundLayer.locations = [0.0, 0.4, 1.0]
        layer.insertSublayer(backgroundLayer, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellWrapper.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 82 // Increased for premium feel
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        // Padding for floating tab bar
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 100, right: 0)
        
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelectChat?(chats[indexPath.row])
    }
    
    // Card-style spacing
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6 // 6px spacing between cards
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // One row per section for card effect
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellWrapper
        cell.node.chat = chats[indexPath.section] // Use section instead of row
        return cell
    }
    
    // Internal wrapper
    private class CellWrapper: UITableViewCell {
        let node = ChatListCellNode()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            backgroundColor = .clear
            contentView.backgroundColor = .clear
            selectionStyle = .none
            contentView.addSubview(node)
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            node.frame = contentView.bounds
        }
    }
}
