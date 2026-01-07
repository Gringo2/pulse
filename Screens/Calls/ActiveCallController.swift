import UIKit

final class ActiveCallController: UIViewController {
    
    private let node = ActiveCallNode()
    private var timer: Timer?
    private var seconds = 0
    private var isMuted = false
    private var isSpeakerOn = false
    
    override func loadView() {
        self.view = node
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCallbacks()
        startCallTimer()
    }
    
    private func setupCallbacks() {
        node.endButton.onTap = { [weak self] in
            self?.endCall()
        }
        
        node.muteButton.onTap = { [weak self] in
            self?.toggleMute()
        }
        
        node.speakerButton.onTap = { [weak self] in
            self?.toggleSpeaker()
        }
    }
    
    private func startCallTimer() {
        node.update(status: "00:00")
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.seconds += 1
            self?.updateTimerLabel()
        }
    }
    
    private func updateTimerLabel() {
        let mins = seconds / 60
        let secs = seconds % 60
        let timeString = String(format: "%02d:%02d", mins, secs)
        node.update(status: timeString)
    }
    
    private func toggleMute() {
        isMuted.toggle()
        let iconName = isMuted ? "mic.slash.fill" : "mic.fill"
        node.muteButton.setIcon(iconName)
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func toggleSpeaker() {
        isSpeakerOn.toggle()
        let iconName = isSpeakerOn ? "speaker.wave.3.fill" : "speaker.wave.2.fill"
        node.speakerButton.setIcon(iconName)
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func endCall() {
        timer?.invalidate()
        dismiss(animated: true)
    }
}
