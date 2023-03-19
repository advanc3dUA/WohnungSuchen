//
//  BackgroundAudioPlayer.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 19.03.2023.
//

import UIKit
import AVFoundation

class BackgroundAudioPlayer {
    private var audioPlayer: AVAudioPlayer?
    
    func start(for controller: AVAudioPlayerDelegate) {
        guard let url = Bundle.main.url(forResource: "SilentSong", withExtension: "wav") else {
            print("Couldn't find audio file")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            audioPlayer?.delegate = controller
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
    
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
