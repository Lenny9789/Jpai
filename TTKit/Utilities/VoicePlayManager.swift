import Foundation
import UIKit
import AVFoundation

class VoicePlayManager: NSObject {
    
    var player: AVAudioPlayer!

    private var playFinished: (() -> Void)?

    func playVoice(with filePath: String, completion: @escaping (() -> Void)) -> Bool {
        playFinished = completion
        
        freePlayer()
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
        if player == nil {
            return false
        }
        
        player.volume = 1.0
        player.delegate = self
        player.prepareToPlay()
        let result = player.play()
        
        if result {
            //设置录音类型
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            
            UIDevice.current.isProximityMonitoringEnabled = true
            NotificationCenter.default.addObserver(self, selector: #selector(sensorStateChange), name: UIDevice.proximityStateDidChangeNotification, object: nil)
        }
        
        return result
    }
    
    func isPlaying() -> Bool {
        if player != nil, player.isPlaying {
            return true
        } else {
            return false
        }
    }
    
    func stopVoice() {
        if player != nil, player.isPlaying {
            player.stop()
        }
    }
    
    func freePlayer() {
        if player != nil {
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            UIDevice.current.isProximityMonitoringEnabled = false
            player.stop()
            player.delegate = nil
            player = nil
        }
    }
    
    @objc func sensorStateChange() {
        if UIDevice.current.proximityState {
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        } else {
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        }
    }
}

// MARK: - AVAudioPlayerDelegate
extension VoicePlayManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let playFinished = self.playFinished {
            playFinished()
        }
    }
}
