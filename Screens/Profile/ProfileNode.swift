import UIKit

final class ProfileNode: Node, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // UI Elements
    private let backgroundLayer = CAGradientLayer()
    private let scrollView = UIScrollView()
    private let container = UIView()
    
    // Profile Header
    private let avatarContainer = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let bioLabel = UILabel()
    
    // Stats / Actions (Mocked layout similar to design)
    private let actionStack = UIStackView()
    
    // Media Section
    private let mediaLabel = UILabel()
    private var collectionView: UICollectionView!
    
    private let mediaImages = ["photo.fill", "video.fill", "waveform.path.ecg", "mic.fill", "doc.fill", "star.fill"]
    
    override func setup() {
        backgroundColor = Theme.Colors.background
        
        // Background
        backgroundLayer.colors = [
            UIColor(hex: "#050505").cgColor,
            UIColor(hex: "#121424").cgColor,
            UIColor(hex: "#050505").cgColor
        ]
        backgroundLayer.locations = [0.0, 0.3, 1.0]
        layer.insertSublayer(backgroundLayer, at: 0)
        
        addSubview(scrollView)
        scrollView.addSubview(container)
        
        // Avatar
        avatarContainer.backgroundColor = Theme.Colors.glassBackground
        avatarContainer.layer.cornerRadius = 60
        avatarContainer.layer.borderColor = Theme.Colors.glassBorder.cgColor
        avatarContainer.layer.borderWidth = 1
        
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.tintColor = .white
        avatarImageView.contentMode = .scaleAspectKey
        avatarImageView.layer.cornerRadius = 60
        avatarImageView.clipsToBounds = true
        
        container.addSubview(avatarContainer)
        avatarContainer.addSubview(avatarImageView)
        
        // Info
        nameLabel.text = "Pulse User"
        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        
        bioLabel.text = "Design enthusiast. Pulse Early Adopter.\nLiving in the future."
        bioLabel.font = .systemFont(ofSize: 15, weight: .regular)
        bioLabel.textColor = Theme.Colors.secondaryText
        bioLabel.textAlignment = .center
        bioLabel.numberOfLines = 0
        
        container.addSubnodes([nameLabel, bioLabel])
        
        // Actions (Call, Video, Mute)
        let actions = ["phone.fill", "video.fill", "bell.slash.fill"]
        for icon in actions {
            let btn = GlassButtonComponent(title: "", iconName: icon)
            actionStack.addArrangedSubview(btn)
        }
        actionStack.axis = .horizontal
        actionStack.distribution = .fillEqually
        actionStack.spacing = 16
        
        container.addSubview(actionStack)
        
        // Media Grid
        mediaLabel.text = "Shared Media"
        mediaLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        mediaLabel.textColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.isScrollEnabled = false // Scroll handled by parent ScrollView
        
        container.addSubnodes([mediaLabel, collectionView])
    }
    
    // MARK: - CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12 // Mock items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        
        // Add mock image
        let img = UIImageView(image: UIImage(systemName: mediaImages[indexPath.item % mediaImages.count]))
        img.tintColor = UIColor.white.withAlphaComponent(0.3)
        img.contentMode = .scaleAspectFit
        img.frame = cell.contentView.bounds.insetBy(dx: 20, dy: 20)
        
        // Clear old subviews if reused
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(img)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 4) / 3
        return CGSize(width: width, height: width)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        scrollView.frame = bounds
        
        let contentWidth = bounds.width
        
        // Avatar
        avatarContainer.frame = CGRect(x: (contentWidth - 120)/2, y: 40, width: 120, height: 120)
        avatarImageView.frame = avatarContainer.bounds
        
        // Text
        nameLabel.frame = CGRect(x: 20, y: avatarContainer.frame.maxY + 20, width: contentWidth - 40, height: 34)
        
        let bioSize = bioLabel.sizeThatFits(CGSize(width: contentWidth - 60, height: .greatestFiniteMagnitude))
        bioLabel.frame = CGRect(x: 30, y: nameLabel.frame.maxY + 8, width: contentWidth - 60, height: bioSize.height)
        
        // Actions
        actionStack.frame = CGRect(x: 40, y: bioLabel.frame.maxY + 30, width: contentWidth - 80, height: 50)
        
        // Media
        mediaLabel.frame = CGRect(x: 20, y: actionStack.frame.maxY + 40, width: contentWidth - 40, height: 24)
        
        let cols: CGFloat = 3
        let width = (contentWidth - 40) // 20 padding each side
        let itemSize = (width - 4) / cols
        let rows = ceil(12.0 / cols)
        let gridHeight = rows * itemSize + (rows * 2)
        
        collectionView.frame = CGRect(x: 20, y: mediaLabel.frame.maxY + 16, width: width, height: gridHeight)
        
        // Container content size
        let totalHeight = collectionView.frame.maxY + 50
        container.frame = CGRect(x: 0, y: 0, width: contentWidth, height: totalHeight)
        scrollView.contentSize = CGSize(width: contentWidth, height: totalHeight)
    }
}
