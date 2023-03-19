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
}
