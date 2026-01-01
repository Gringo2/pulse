import UIKit

/// Centralized design tokens for the Pulse Premium UI.
/// Matches the aesthetic of pulse_premium_ui_showcase.png
enum Theme {
    
    enum Colors {
        static let background = UIColor(hex: "#050505")
        static let accent = UIColor(hex: "#007AFF")
        static let secondaryText = UIColor(hex: "#8E8E93")
        static let glassBackground = UIColor.white.withAlphaComponent(0.08)
        static let glassBorder = UIColor.white.withAlphaComponent(0.12)
        
        // Gradients
        static let bubbleOutgoing = [UIColor(hex: "#00A2FF"), UIColor(hex: "#0062FF")]
        static let bubbleIncoming = [UIColor(hex: "#2C2C2E")]
    }
    
    enum Spacing {
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 12
        static let cardRadius: CGFloat = 20
        static let bubbleRadius: CGFloat = 18
    }
    
    enum Animation {
        static let springDamping: CGFloat = 0.8
        static let springResponse: CGFloat = 0.4
    }
}

// MARK: - UIColor Extension
extension UIColor {
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            self.init(white: 0, alpha: 1)
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
