//
//  ModalVCDelegate.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 24.03.2023.
//

import Foundation

protocol ModalVCDelegate {
    var options: Options { get set }
    func startEngine()
    func pauseEngine()
    func stopEngine()
}
