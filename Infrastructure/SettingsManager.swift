import Foundation

/// Manages local user preferences and app settings.
final class SettingsManager {
    static let shared = SettingsManager()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let isFluidEnabled = "isFluidEnabled"
        static let isSoundsEnabled = "isSoundsEnabled"
        static let isVibrationEnabled = "isVibrationEnabled"
    }
    
    // Default values if nothing is set
    init() {
        if defaults.object(forKey: Keys.isFluidEnabled) == nil {
            defaults.set(true, forKey: Keys.isFluidEnabled)
        }
        if defaults.object(forKey: Keys.isSoundsEnabled) == nil {
            defaults.set(true, forKey: Keys.isSoundsEnabled)
        }
        if defaults.object(forKey: Keys.isVibrationEnabled) == nil {
            defaults.set(true, forKey: Keys.isVibrationEnabled)
        }
    }
    
    var isFluidEnabled: Bool {
        get { defaults.bool(forKey: Keys.isFluidEnabled) }
        set { defaults.set(newValue, forKey: Keys.isFluidEnabled) }
    }
    
    var isSoundsEnabled: Bool {
        get { defaults.bool(forKey: Keys.isSoundsEnabled) }
        set { defaults.set(newValue, forKey: Keys.isSoundsEnabled) }
    }
    
    var isVibrationEnabled: Bool {
        get { defaults.bool(forKey: Keys.isVibrationEnabled) }
        set { defaults.set(newValue, forKey: Keys.isVibrationEnabled) }
    }
}
