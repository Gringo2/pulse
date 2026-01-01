import UIKit

/// Manages the list of messages.
/// Uses a similar TableView wrapper approach as ChatListNode but optimized for bottom-scrolling.
final class MessageListNode: Node, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    var messages: [Message] = []
    
    override func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCellWrapper.self, forCellReuseIdentifier: "MessageCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    func update(messages: [Message]) {
        self.messages = messages
        tableView.reloadData()
        scrollToBottom()
    }
    
    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCellWrapper
        cell.node.message = messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let msg = messages[indexPath.row]
        return MessageBubbleNode.calculateHeight(for: msg, width: tableView.bounds.width)
    }
    
    // Internal Wrapper
    private class MessageCellWrapper: UITableViewCell {
        let node = MessageBubbleNode()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            backgroundColor = .clear
            contentView.addSubview(node)
            selectionStyle = .none
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            node.frame = contentView.bounds
        }
    }
}
