//
//  ModalVC.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 24.03.2023.
//

import UIKit
import Combine

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
    var cancellables: Set<AnyCancellable> = []
    
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
    
    //MARK: - VC Lifecycle
    
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
        setOptionsPublishers()
    }
    
    //MARK: - Save button

    private func setOptionsPublishers() {
        let roomsMinTextFieldPublisher = modalView.optionsView.roomsMinTextField.publisher(for: \.text)
        let roomsMaxTextFieldPublisher = modalView.optionsView.roomsMaxTextField.publisher(for: \.text)
        let areaMinTextFieldPublisher = modalView.optionsView.areaMinTextField.publisher(for: \.text)
        let areaMaxTextFieldPublisher = modalView.optionsView.areaMaxTextField.publisher(for: \.text)
        let rentMinTextFieldPublisher = modalView.optionsView.rentMinTextField.publisher(for: \.text)
        let rentMaxTextFieldPublisher = modalView.optionsView.rentMaxTextField.publisher(for: \.text)
        let timerUpdateTextFieldPublisher = modalView.optionsView.timerUpdateTextField.publisher(for: \.text)
        
        
        let roomsMinIntPublisher = roomsMinTextFieldPublisher
            .removeDuplicates()
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.roomsMin)
            }
        let roomsMaxIntPublisher = roomsMaxTextFieldPublisher
            .removeDuplicates()
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.roomsMax)
            }
        
        let areaMinIntPublisher = areaMinTextFieldPublisher
            .removeDuplicates()
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.areaMin)
            }
        let areaMaxIntPublisher = areaMaxTextFieldPublisher
            .removeDuplicates()
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.areaMax)
            }
        
        let rentMinIntPublisher = rentMinTextFieldPublisher
            .removeDuplicates()
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.rentMin)
            }
        let rentMaxIntPublisher = rentMaxTextFieldPublisher
            .removeDuplicates()
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.rentMax)
            }
        
        let timerUpdateIntPublisher = timerUpdateTextFieldPublisher
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: options.updateTime)
            }
            .scan(nil) { previous, current in
                    if current < 30 {
                        self.modalView.optionsView.timerUpdateTextField.text = "30"
                        if previous == nil || previous == 30 {
                            return nil
                        } else {
                            return 30
                        }
                    } else {
                        return current
                    }
                }
            .compactMap { $0 }
            .removeDuplicates()

        let roomsPub = Publishers.CombineLatest(roomsMinIntPublisher, roomsMaxIntPublisher)
        let areaPub = Publishers.CombineLatest(areaMinIntPublisher, areaMaxIntPublisher)
        let rentPub = Publishers.CombineLatest(rentMinIntPublisher, rentMaxIntPublisher)
        
        Publishers.CombineLatest4(roomsPub, areaPub, rentPub, timerUpdateIntPublisher)
            .dropFirst()
            .map { [unowned self] rooms, area, rent, updateTime in
                options.roomsMin = rooms.0
                options.roomsMax = rooms.1
                options.areaMin = area.0
                options.areaMax = area.1
                options.rentMin = rent.0
                options.rentMax = rent.1
                options.updateTime = updateTime
                return rooms.0 <= rooms.1 && area.0 <= area.1 && rent.0 <= rent.0
            }
            .sink { [unowned self] isValid in
                modalView.saveButtonIsEnabled(isValid)
                delegate?.options = options
            }
            .store(in: &cancellables)
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
    
    @objc private func hideKeyboard() {
        modalView.optionsView.roomsMinTextField.resignFirstResponder()
        modalView.optionsView.roomsMaxTextField.resignFirstResponder()
        modalView.optionsView.areaMinTextField.resignFirstResponder()
        modalView.optionsView.areaMaxTextField.resignFirstResponder()
        modalView.optionsView.rentMinTextField.resignFirstResponder()
        modalView.optionsView.rentMaxTextField.resignFirstResponder()
        modalView.optionsView.timerUpdateTextField.resignFirstResponder()
    }
}
