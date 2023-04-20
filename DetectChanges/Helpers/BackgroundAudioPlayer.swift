//
//  BackgroundAudioPlayer.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 19.03.2023.
//

import UIKit
import AVFoundation

class BackgroundAudioPlayer {
    var audioPlayer: AVAudioPlayer?
    private var controller: AVAudioPlayerDelegate
    
    init(for controller: AVAudioPlayerDelegate) {
        self.controller = controller
    }
    
    public func start() {
        guard let url = Bundle.main.url(forResource: "SilentSong", withExtension: "wav") else {
//        guard let url = Bundle.main.url(forResource: "heavy-rain", withExtension: "wav") else {
            print("Couldn't find audio file")
            return
        }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: .mixWithOthers)
            try session.setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            audioPlayer?.delegate = controller
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
    
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
