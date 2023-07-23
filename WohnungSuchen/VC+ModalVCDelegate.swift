//
//  ViewController+ModalVCDelegate.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 23.07.2023.
//

import UIKit

extension ViewController: ModalVCDelegate {
    func didTapStartButton() {
        startEngine()
    }
    
    func didTapPauseButton() {
        pauseEngine()
    }
    
    
}

