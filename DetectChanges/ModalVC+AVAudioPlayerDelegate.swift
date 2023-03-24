//
//  ModalVC+AVAudioPlayerDelegate.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 24.03.2023.
//

import Foundation

import UIKit
import AVFoundation

extension ModalVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            player.play()
        }
    }
}
