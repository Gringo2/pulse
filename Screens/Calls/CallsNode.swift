import UIKit

final class CallsNode: Node, UITableViewDelegate, UITableViewDataSource {
    
    private let backgroundLayer = CAGradientLayer()
    private let tableView = UITableView()
    private var calls: [Call] = []
    
    var onSelectCall: ((Call) -> Void)?
    
    override func setup() {
        backgroundColor = Theme.Colors.background
        
        // Vibrant background gradient
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
        tableView.register(CallCellNode.self, forCellReuseIdentifier: "CallCell")
        tableView.rowHeight = 82
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 100, right: 0)
        
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        tableView.frame = bounds
    }
    
    func update(calls: [Call]) {
        self.calls = calls
        tableView.reloadData()
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return calls.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6 // Card spacing
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCellNode
        cell.call = calls[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelectCall?(calls[indexPath.section])
    }
}

// MARK: - Cell Node
final class CallCellNode: UITableViewCell {
    
    var call: Call? {
        didSet { updateContent() }
    }
    
    private let container = UIView()
    private let avatarContainer = UIView()
    private let avatarGradient = CAGradientLayer()
    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let statusIcon = UIImageView()
    private let statusLabel = UILabel()
    private let timeLabel = UILabel()
    private let infoButton = UIButton(type: .infoLight)
    
    private lazy var highlightAnimator = HighlightAnimator(view: container)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
        
        // Premium Card Styling (50px Radius)
        container.backgroundColor = UIColor.white.withAlphaComponent(0.02)
        container.layer.cornerRadius = 50
        container.layer.borderWidth = 0.5
        container.layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        container.clipsToBounds = true
        
        // Avatar
        avatarGradient.cornerRadius = 24
        avatarGradient.colors = [Theme.Colors.accent.cgColor, UIColor(hex: "#00A2FF").cgColor]
        avatarContainer.layer.addSublayer(avatarGradient)
        
        avatarView.tintColor = .white
        avatarView.contentMode = .center
        avatarView.layer.cornerRadius = 24
        avatarView.layer.masksToBounds = true
        
        // Labels
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .white
        
        statusIcon.tintColor = UIColor.white.withAlphaComponent(0.6)
        statusIcon.contentMode = .scaleAspectFit
        
        statusLabel.font = .systemFont(ofSize: 15, weight: .regular)
        statusLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        
        timeLabel.font = .systemFont(ofSize: 15, weight: .regular)
        timeLabel.textColor = UIColor.white.withAlphaComponent(0.4)
        
        infoButton.tintColor = Theme.Colors.accent
        
        contentView.addSubview(container)
        container.addSubview(avatarContainer)
        container.addSubview(avatarView)
        container.addSubview(nameLabel)
        container.addSubview(statusIcon)
        container.addSubview(statusLabel)
        container.addSubview(timeLabel)
        container.addSubview(infoButton)
    }
    
    private func updateContent() {
        guard let call = call else { return }
        nameLabel.text = call.name
        statusLabel.text = call.status.rawValue.capitalized
        timeLabel.text = call.timeString
        
        let config = UIImage.SymbolConfiguration(weight: .bold)
        statusIcon.image = UIImage(systemName: call.statusIconName, withConfiguration: config)
        
        if call.status == .missed {
            statusLabel.textColor = .systemRed
            statusIcon.tintColor = .systemRed
            nameLabel.textColor = .systemRed
        } else {
            statusLabel.textColor = UIColor.white.withAlphaComponent(0.6)
            statusIcon.tintColor = UIColor.white.withAlphaComponent(0.6)
            nameLabel.textColor = .white
        }
        
        if let avatar = call.avatarName {
            avatarView.image = UIImage(systemName: avatar)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.frame = contentView.bounds
        avatarGradient.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        
        let horizontalPadding: CGFloat = 16
        let avatarSize: CGFloat = 48
        
        avatarContainer.frame = CGRect(x: horizontalPadding, y: (bounds.height - avatarSize)/2, width: avatarSize, height: avatarSize)
        avatarView.frame = avatarContainer.frame
        
        let textLeft = avatarView.frame.maxX + 14
        let infoWidth: CGFloat = 44
        let textRight = bounds.width - infoWidth
        
        nameLabel.frame = CGRect(x: textLeft, y: 18, width: textRight - textLeft, height: 22)
        
        statusIcon.frame = CGRect(x: textLeft, y: nameLabel.frame.maxY + 4, width: 14, height: 14)
        statusLabel.frame = CGRect(x: statusIcon.frame.maxX + 4, y: nameLabel.frame.maxY + 2, width: 100, height: 18)
        
        infoButton.frame = CGRect(x: bounds.width - infoWidth - 8, y: (bounds.height - infoWidth)/2, width: infoWidth, height: infoWidth)
        
        timeLabel.sizeToFit()
        timeLabel.frame = CGRect(x: infoButton.frame.minX - timeLabel.frame.width - 8, y: (bounds.height - 18)/2, width: timeLabel.frame.width, height: 18)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        highlightAnimator.animateHighlight(true)
        UIView.animate(withDuration: 0.1) {
            self.container.backgroundColor = UIColor.white.withAlphaComponent(0.06)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        highlightAnimator.animateHighlight(false)
        UIView.animate(withDuration: 0.3) {
            self.container.backgroundColor = UIColor.white.withAlphaComponent(0.02)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        highlightAnimator.animateHighlight(false)
        UIView.animate(withDuration: 0.3) {
            self.container.backgroundColor = UIColor.white.withAlphaComponent(0.02)
        }
    }
}
