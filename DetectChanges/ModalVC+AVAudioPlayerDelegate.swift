//
//  ModalVC+AVAudioPlayerDelegate.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 24.03.2023.
//

import UIKit
import AVFoundation

extension ModalVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            player.play()
        }
    }
    
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        bgAudioPlayerIsInterrupted = true
        player.pause()
    }
    
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
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
