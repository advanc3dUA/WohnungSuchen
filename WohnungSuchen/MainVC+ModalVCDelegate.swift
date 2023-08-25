//
//  MainVC+ModalVCDelegate.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 23.07.2023.
//

import UIKit

extension MainVC: ModalVCDelegate {
    func didTapStartButton() {
        startEngine()
    }

    func didTapPauseButton() {
        pauseEngine()
    }

}
