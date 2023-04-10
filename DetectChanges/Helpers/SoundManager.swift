//
//  SoundManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 12.03.2023.
//

import Foundation
import AVFoundation

struct SoundManager {
    var player: AVAudioPlayer?
    var volume: Float = 7
    
    mutating func setVolume(to volume: Float) {
        self.volume = volume
    }
    
    mutating func playAlert(if soundIsOn: Bool) {
        //  guard let url = Bundle.main.url(forResource: "sci-fi", withExtension: "wav") else { return }
        //  guard let url = Bundle.main.url(forResource: "chicken", withExtension: "mp3") else { return }
        //  guard let url = Bundle.main.url(forResource: "fanfare", withExtension: "mp3") else { return }
        if soundIsOn {
            player?.volume = volume / 10
            guard let url = Bundle.main.url(forResource: "IntelPentiumSound", withExtension: "mp3") else { return }
            player = try! AVAudioPlayer(contentsOf: url)
            player?.play()
        }
    }
}
