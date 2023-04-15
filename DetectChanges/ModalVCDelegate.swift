//
//  ModalVCDelegate.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 24.03.2023.
//

import Foundation

protocol ModalVCDelegate {
    func startEngine()
    func pauseEngine()
    func stopEngine()
    func updateSoundManagerAlertType(with status: Bool)
    func updateSoundManagerVolume(with value: Float)
}
