//
//  ModalVC.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 24.03.2023.
//

import UIKit

class ModalVC: UIViewController {
    var currentDetent: UISheetPresentationController.Detent.Identifier?
    var modalView: ModalView!
    var requiredApartment: Apartment
    var landlordsManager: LandlordsManager
    var soundManager: SoundManager
    var backgroundAudioPlayer: BackgroundAudioPlayer?
    var consolePrinter: ConsolePrinter
    var delegate: ModalVCDelegate?
    var isSecondRunPlus: Bool
    var bgAudioPlayerIsInterrupted: Bool
    
    init(mediumDetentSize: CGFloat) {
        self.soundManager = SoundManager()
        self.consolePrinter = ConsolePrinter()
        self.requiredApartment = Apartment(rooms: 2, area: 40)
        self.landlordsManager = LandlordsManager(requiredApartment: requiredApartment)
        self.isSecondRunPlus = false
        bgAudioPlayerIsInterrupted = false
        currentDetent = .medium
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        self.modalView = ModalView(for: view)
        view.addSubview(modalView)
        backgroundAudioPlayer = BackgroundAudioPlayer(for: self)
        backgroundAudioPlayer?.start()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let buttonsContainerView = modalView.buttonsContainerView else { return }
        Constants.apartButtonsWidth = (buttonsContainerView.frame.width - 2 * Constants.spacing) / CGFloat(Constants.maxButtonsPerRow)
        Constants.immoButtonWidth = (Constants.apartButtonsWidth - Constants.apartSpacing) * Constants.immoButtonPercentage
    }
      
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) {[unowned self] timer in
            landlordsManager.start { apartments in
                DispatchQueue.main.async { [unowned self] in
                    apartments.forEach { apartment in
                        delegate?.updateConsoleTextView(withText: consolePrinter.foundNew(apartment))
                    }
                    modalView.buttonsContainerView.showButtons(for: apartments) // temp?
                    if isSecondRunPlus {
                        if !apartments.isEmpty {
                            modalView.buttonsContainerView.removeAllSubviews()
                            soundManager.playAlert()
                            makeFeedback()
                        }
                        modalView.buttonsContainerView.showButtons(for: apartments)
                    }
                    
                    if apartments.isEmpty {
                        delegate?.updateConsoleTextView(withText: consolePrinter.notFound())
                    }
                    isSecondRunPlus = true
                }
            }
        }.fire()
    }
    
    //MARK: - Supporting methods
    private func setupSheetPresentationController(with mediumDetent: UISheetPresentationController.Detent) {
        sheetPresentationController?.detents = [mediumDetent, .large()]
        
        // Sheet setup
        sheetPresentationController?.largestUndimmedDetentIdentifier = .large
        sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = true
        sheetPresentationController?.prefersEdgeAttachedInCompactHeight = true
        sheetPresentationController?.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        sheetPresentationController?.prefersGrabberVisible = false
        sheetPresentationController?.preferredCornerRadius = 20
        
        // Disables hiding TraineeVC
        isModalInPresentation = true
    }
    
    private func makeFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        let timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            generator.prepare()
            generator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            timer.invalidate()
        }
    }
}
