import UIKit

final class CallsNode: Node, UITableViewDelegate, UITableViewDataSource {
    
    private let backgroundLayer = CAGradientLayer()
    private let tableView = UITableView()
    private let emptyLabel = UILabel()
    private let segmentControl = UISegmentedControl(items: ["All", "Missed"])
    private var allCalls: [Call] = []
    private var filteredCalls: [Call] = []
    
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
        tableView.contentInsetAdjustmentBehavior = .never // Fix double-insetting
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 100, right: 0)
        
        // Segment Control
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        segmentControl.selectedSegmentTintColor = Theme.Colors.accent
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 13, weight: .semibold)], for: .selected)
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        // Empty Label
        emptyLabel.text = "No Recent Calls"
        emptyLabel.font = .systemFont(ofSize: 17, weight: .medium)
        emptyLabel.textColor = UIColor.white.withAlphaComponent(0.4)
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true
        
        addSubview(segmentControl)
        addSubview(tableView)
        addSubview(emptyLabel)
        
        tableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 100, right: 0)
    }
    
    @objc private func segmentChanged() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        filterCalls()
    }
    
    private func filterCalls() {
        if segmentControl.selectedSegmentIndex == 1 {
            filteredCalls = allCalls.filter { $0.status == .missed }
        } else {
            filteredCalls = allCalls
        }
        emptyLabel.isHidden = !filteredCalls.isEmpty
        tableView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        tableView.frame = bounds
        emptyLabel.frame = bounds
        
        // Segment Control
        let segmentWidth: CGFloat = 200
        let segmentY = safeAreaInsets.top + 8
        segmentControl.frame = CGRect(x: (bounds.width - segmentWidth)/2, y: segmentY, width: segmentWidth, height: 32)
        
        // Adjust table insets
        let topInset = segmentY + 32 + 12
        tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: safeAreaInsets.bottom + 100, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: safeAreaInsets.bottom, right: 0)
    }
    
    func update(calls: [Call]) {
        self.allCalls = calls
        filterCalls()
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCalls.count
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
        cell.call = filteredCalls[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelectCall?(filteredCalls[indexPath.section])
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

    private let phoneButton = UIButton(type: .system)
    private let videoButton = UIButton(type: .system)
    
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
        

        
        phoneButton.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        phoneButton.tintColor = UIColor.white.withAlphaComponent(0.6)
        
        videoButton.setImage(UIImage(systemName: "video.fill"), for: .normal)
        videoButton.tintColor = UIColor.white.withAlphaComponent(0.6)
        
        contentView.addSubview(container)
        container.addSubview(avatarContainer)
        container.addSubview(avatarView)
        container.addSubview(nameLabel)
        container.addSubview(statusIcon)
        container.addSubview(statusLabel)
        container.addSubview(timeLabel)
        container.addSubview(phoneButton)
        container.addSubview(videoButton)
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
        
        let iconSize: CGFloat = 36
        videoButton.frame = CGRect(x: bounds.width - horizontalPadding - iconSize, y: (bounds.height - iconSize)/2, width: iconSize, height: iconSize)
        phoneButton.frame = CGRect(x: videoButton.frame.minX - iconSize - 8, y: (bounds.height - iconSize)/2, width: iconSize, height: iconSize)
        
        timeLabel.sizeToFit()
        let timeWidth = timeLabel.frame.width
        timeLabel.frame = CGRect(x: phoneButton.frame.minX - timeWidth - 12, y: (bounds.height - 18)/2, width: timeWidth, height: 18)
        
        let textLeft = avatarView.frame.maxX + 14
        let textRightLimit = timeLabel.frame.minX - 8
        
        // Name - Truncate if needed
        nameLabel.frame = CGRect(x: textLeft, y: 18, width: textRightLimit - textLeft, height: 22)
        
        // Status row
        statusIcon.frame = CGRect(x: textLeft, y: nameLabel.frame.maxY + 4, width: 14, height: 14)
        let statusLabelMaxWidth = textRightLimit - statusIcon.frame.maxX - 4
        statusLabel.frame = CGRect(x: statusIcon.frame.maxX + 4, y: nameLabel.frame.maxY + 2, width: statusLabelMaxWidth, height: 18)
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
