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
    
    public func start(for controller: AVAudioPlayerDelegate) {
        guard let url = Bundle.main.url(forResource: "SilentSong", withExtension: "wav") else {
//        guard let url = Bundle.main.url(forResource: "heavy-rain", withExtension: "wav") else {
            print("Couldn't find audio file")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            audioPlayer?.delegate = controller
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
    
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func pause() {
        guard let player = audioPlayer else { return }
        player.pause()
    }
    
    public func continuePlaying() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [unowned self] in
            guard let player = audioPlayer else { return }
            player.play()
        }
    }
}
