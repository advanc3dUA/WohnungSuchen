//
//  ModalVC.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 24.03.2023.
//

import UIKit

class ModalVC: UIViewController {
    var currentDetent: UISheetPresentationController.Detent.Identifier?
    
    init(mediumDetentSize: CGFloat) {
        currentDetent = .medium
        super.init(nibName: nil, bundle: nil)
        
        // Custom medium detent
        let mediumID = UISheetPresentationController.Detent.Identifier("medium")
        let mediumDetent = UISheetPresentationController.Detent.custom(identifier: mediumID) { context in
            return mediumDetentSize
        }
        
        sheetPresentationController?.detents = [mediumDetent, .large()]
        
        // Sheet setup
        sheetPresentationController?.largestUndimmedDetentIdentifier = .large
        sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = true
        sheetPresentationController?.prefersEdgeAttachedInCompactHeight = true
        sheetPresentationController?.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        sheetPresentationController?.prefersGrabberVisible = false
        sheetPresentationController?.preferredCornerRadius = 27
        
        // Disables hiding TraineeVC
        isModalInPresentation = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
    }
}
