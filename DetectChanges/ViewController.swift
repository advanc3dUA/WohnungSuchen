//
//  ViewController.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var consoleTextView: UITextView!
    var modalVC: ModalVC?
    
    //MARK: - VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentModalVC()
        setupConsoleTextView()
    }
    
    private func presentModalVC() {
        modalVC = ModalVC(mediumDetentSize: calcTraineeVCDetentSizeMedium())
        modalVC?.presentationController?.delegate = self
        modalVC?.delegate = self
        present(modalVC!, animated: true)
    }
    
    private func scrollToBottom(_ textView: UITextView) {
        guard !textView.text.isEmpty else { return }
        let range = NSMakeRange(textView.text.count - 1, 1)
        textView.scrollRangeToVisible(range)
        let bottomOffset = CGPoint(x: 0, y: textView.contentSize.height - textView.frame.height)
        if bottomOffset.y > 0 {
            textView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    private func setupConsoleTextView() {
        consoleTextView.layer.cornerRadius = 20
    }
}

// MARK: - DetectDetent Protocol

extension ViewController: DetectDetent {
    func detentChanged(detent: UISheetPresentationController.Detent.Identifier) {
        switchModalVCCurrentDetent(to: detent)
    }
    
    private func switchModalVCCurrentDetent(to detent: UISheetPresentationController.Detent.Identifier) {
        modalVC?.currentDetent = detent
    }
    
    private func calcTraineeVCDetentSizeMedium() -> CGFloat {
        self.view.frame.height * 0.3
    }
    
}

//MARK: - UISheetPresentationControllerDelegate

extension ViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        if let currentDetent = sheetPresentationController.selectedDetentIdentifier {
            detentChanged(detent: currentDetent)
        }
    }
}

//MARK: - ModalVCDelegate
extension ViewController: ModalVCDelegate {
    func updateConsoleTextView(withText text: String) {
        consoleTextView.text += text
        scrollToBottom(consoleTextView)
    }
}
