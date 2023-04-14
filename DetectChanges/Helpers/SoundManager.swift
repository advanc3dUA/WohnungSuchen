//
//  SoundManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 12.03.2023.
//

import Foundation
import AVFoundation

struct SoundManager {
    var player: AVAudioPlayer
    var volume: Float
    
    init() {
        self.player = AVAudioPlayer()
        self.volume = 7.0
    }
    
    mutating func setVolume(to volume: Float) {
        self.volume = volume
    }
    
    mutating func playAlert(if soundIsOn: Bool) {
        if soundIsOn {
            guard let url = Bundle.main.url(forResource: "IntelPentiumSound", withExtension: "mp3") else { return }
            do {
                player = try AVAudioPlayer(contentsOf: url)
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                player.prepareToPlay()
                player.volume = volume / 10
                player.play()
            } catch let error {
                print("Error playing alert \(error.localizedDescription)")
            }
        }
    }
}
