//
//  VC+AVAudioPlayerDelegate.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 19.03.2023.
//

import UIKit
import AVFoundation

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            player.play()
        }
    }
    
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        if player == backgroundAudioPlayer?.audioPlayer {
            bgAudioPlayerIsInterrupted = true
            player.pause()
        }
    }
    
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        if player == backgroundAudioPlayer?.audioPlayer {
            guard bgAudioPlayerIsInterrupted else { return }
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                player.play()
            }
            
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
