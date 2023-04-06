//
//  ModalVC.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 24.03.2023.
//

import UIKit

class ModalVC: UIViewController {
    var modalView: ModalView!
    var currentDetent: UISheetPresentationController.Detent.Identifier?
    var delegate: ModalVCDelegate?
    var backgroundAudioPlayer: BackgroundAudioPlayer?
    var bgAudioPlayerIsInterrupted: Bool
    
    init(mediumDetentSize: CGFloat) {
        currentDetent = .medium
        bgAudioPlayerIsInterrupted = false
        super.init(nibName: nil, bundle: nil)
        
        // Custom medium detent
        let mediumID = UISheetPresentationController.Detent.Identifier("medium")
        let mediumDetent = UISheetPresentationController.Detent.custom(identifier: mediumID) { context in
            return mediumDetentSize
        }
        setupSheetPresentationController(with: mediumDetent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        modalView = ModalView()
        view = modalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundAudioPlayer = BackgroundAudioPlayer(for: self)
        backgroundAudioPlayer?.start()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Supporting methods
    private func setupSheetPresentationController(with mediumDetent: UISheetPresentationController.Detent) {
        sheetPresentationController?.detents = [mediumDetent, .large()]
        sheetPresentationController?.largestUndimmedDetentIdentifier = .large
        sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = true
        sheetPresentationController?.prefersEdgeAttachedInCompactHeight = true
        sheetPresentationController?.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        sheetPresentationController?.prefersGrabberVisible = false
        sheetPresentationController?.preferredCornerRadius = 20
        
        // Disables hiding TraineeVC
        isModalInPresentation = true
    }
}
