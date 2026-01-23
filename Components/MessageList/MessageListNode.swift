import UIKit

/// Manages the list of messages.
/// Uses a similar TableView wrapper approach as ChatListNode but optimized for bottom-scrolling.
final class MessageListNode: Node, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    private let emptyLabel = UILabel()
    var messages: [Message] = []
    
    var onScrollToTop: (() -> Void)?
    
    override func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCellWrapper.self, forCellReuseIdentifier: "MessageCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        // Empty State
        emptyLabel.text = "Say Hello! 👋"
        emptyLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        emptyLabel.textColor = UIColor.white.withAlphaComponent(0.3)
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true
        
        addSubview(tableView)
        addSubview(emptyLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
        emptyLabel.frame = bounds
    }
    
    func update(messages: [Message]) {
        let isAtBottom = tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height - 20)
        let oldContentHeight = tableView.contentSize.height
        
        self.messages = messages
        emptyLabel.isHidden = !messages.isEmpty
        tableView.reloadData()
        
        if !messages.isEmpty {
            if isAtBottom || messages.count < 5 {
                // If previously at bottom (or first load), stick to bottom
                scrollToBottom(animated: oldContentHeight > 0)
            } else {
                // Maintained position (approximate for history load)
                // In a real app we'd calculate exact height diff
                let newHeight = tableView.contentSize.height
                let diff = newHeight - oldContentHeight
                if diff > 0 {
                    tableView.contentOffset = CGPoint(x: 0, y: tableView.contentOffset.y + diff)
                }
            }
        }
    }
    
    private func scrollToBottom(animated: Bool) {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
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
    
    // MARK: - Scroll Detection
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        // Trigger pagination when scrolled near top
        if offsetY < 100 && contentHeight > 0 {
            onScrollToTop?()
        }
    }
}
