//
//  FeedbackManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 15.04.2023.
//

//import UIKit
//import AVFoundation
//
//enum AlertType {
//    case sound
//    case vibration
//}
//
//class FeedbackManager {
//    private var player: AVAudioPlayer
//    private var volume: Float
//    private var alertType: AlertType
//    
//    init() {
//        self.player = AVAudioPlayer()
//        self.volume = Constants.defaultOptions.volume
//        self.alertType = Constants.defaultOptions.alertType
//    }
//    
//    func setVolume(to volume: Float) {
//        self.volume = volume
//    }
//    
//    func setAlertType(to alertType: AlertType) {
//        self.alertType = alertType
//    }
//    
//    func makeFeedback() {
//        if alertType == .sound {
//            soundAlert()
//        } else {
//            vibrateAlert()
//        }
//    }
//    
//    private func vibrateAlert() {
//        let generator = UIImpactFeedbackGenerator(style: .heavy)
//        generator.prepare()
//        generator.impactOccurred()
//        let timer = Timer.scheduledTimer(withTimeInterval: 0.015, repeats: true) { timer in
//            generator.prepare()
//            generator.impactOccurred()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            timer.invalidate()
//        }
//    }
//    
//    private func soundAlert() {
//        guard let url = Bundle.main.url(forResource: "IntelPentiumSound", withExtension: "mp3") else { return }
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//            player.prepareToPlay()
//            player.volume = volume / 10
//            player.play()
//        } catch let error {
//            print("Error playing alert \(error.localizedDescription)")
//        }
//    }
//}
