//
//  ModalVC.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 24.03.2023.
//

import UIKit

class ModalVC: UIViewController {
    var modalView: ModalView!
    var options: Options
    var currentDetent: UISheetPresentationController.Detent.Identifier? {
        didSet {
            switch currentDetent?.rawValue {
            case "com.apple.UIKit.large": modalView.showOptionsContent()
            case "small": modalView.hideOptionsContent()
            default: return
            }
        }
    }
    var delegate: ModalVCDelegate?
    
    init(smallDetentSize: CGFloat, options: Options) {
        currentDetent = .medium
        self.options = options
        super.init(nibName: nil, bundle: nil)
        
        // Custom medium detent
        let smallID = UISheetPresentationController.Detent.Identifier("small")
        let smallDetent = UISheetPresentationController.Detent.custom(identifier: smallID) { context in
            return smallDetentSize
        }
        setupSheetPresentationController(with: smallDetent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        guard let delegate = delegate else { return }
        modalView = ModalView(delegate: delegate, options: options)
        view = modalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGasture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGasture)
        
        modalView.optionsView.updateOptionsUI(with: options)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @objc private func hideKeyboard() {
        modalView.optionsView.roomsMinTextField.resignFirstResponder()
        modalView.optionsView.roomsMaxTextField.resignFirstResponder()
        modalView.optionsView.areaMinTextField.resignFirstResponder()
        modalView.optionsView.areaMaxTextField.resignFirstResponder()
        modalView.optionsView.rentMinTextField.resignFirstResponder()
        modalView.optionsView.rentMaxTextField.resignFirstResponder()
        modalView.optionsView.timerUpdateTextField.resignFirstResponder()
    }
    
    //MARK: - Supporting methods
    private func setupSheetPresentationController(with smallDetent: UISheetPresentationController.Detent) {
        sheetPresentationController?.detents = [smallDetent, .large()]
        sheetPresentationController?.largestUndimmedDetentIdentifier = .large
        sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = true
        sheetPresentationController?.prefersEdgeAttachedInCompactHeight = true
        sheetPresentationController?.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        sheetPresentationController?.prefersGrabberVisible = false
        sheetPresentationController?.preferredCornerRadius = 10
        
        // Disables hiding TraineeVC
        isModalInPresentation = true
    }
}
