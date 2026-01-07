import UIKit

final class GlassSearchBar: Node {
    
    private let blurView: UIVisualEffectView
    let textField: UITextField
    private let iconView: UIImageView
    
    var onTextChanged: ((String) -> Void)?
    
    override init(frame: CGRect) {
        let effect = UIBlurEffect(style: .systemThinMaterialDark)
        self.blurView = UIVisualEffectView(effect: effect)
        self.textField = UITextField()
        self.iconView = UIImageView()
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func setup() {
        // Validation for blur
        blurView.layer.cornerRadius = 12
        blurView.layer.masksToBounds = true
        
        // Icon
        iconView.image = UIImage(systemName: "magnifyingglass")
        iconView.tintColor = Theme.Colors.secondaryText
        iconView.contentMode = .scaleAspectFit
        
        // TextField
        textField.placeholder = "Search"
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .white
        textField.tintColor = Theme.Colors.accent
        textField.returnKeyType = .search
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
        // Placeholder Color
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: Theme.Colors.secondaryText]
        )
        
        addSubnodes([blurView, iconView, textField])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = bounds
        
        let iconSize: CGFloat = 20
        let padding: CGFloat = 12
        
        iconView.frame = CGRect(x: padding, y: (bounds.height - iconSize)/2, width: iconSize, height: iconSize)
        
        let textX = iconView.frame.maxX + 8
        let textWidth = bounds.width - textX - padding
        textField.frame = CGRect(x: textX, y: 0, width: textWidth, height: bounds.height)
    }
    
    @objc private func textChanged() {
        onTextChanged?(textField.text ?? "")
    }
}
