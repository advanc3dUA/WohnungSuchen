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
    
    mutating func playAlert() {
//        guard let url = Bundle.main.url(forResource: "sci-fi", withExtension: "wav") else { return }
//        guard let url = Bundle.main.url(forResource: "chicken", withExtension: "mp3") else { return }
        guard let url = Bundle.main.url(forResource: "fanfare", withExtension: "mp3") else { return }
        player = try! AVAudioPlayer(contentsOf: url)
        player?.play()
    }
}
