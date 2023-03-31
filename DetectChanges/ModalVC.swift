//
//  ModalVC.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 24.03.2023.
//

import UIKit

class ModalVC: UIViewController {
    var currentDetent: UISheetPresentationController.Detent.Identifier?
    var containerView: UIView!
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupContainerView()
        setupStartStopButton()
        backgroundAudioPlayer = BackgroundAudioPlayer(for: self)
        backgroundAudioPlayer?.start()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Constants.apartButtonsWidth = (containerView.frame.width - 2 * Constants.spacing) / CGFloat(Constants.maxButtonsPerRow)
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
                    showButtons(for: apartments) // temp?
                    if isSecondRunPlus {
                        if !apartments.isEmpty {
                            containerView.removeAllSubviews()
                            soundManager.playAlert()
                            makeFeedback()
                        }
                        showButtons(for: apartments)
                    }
                    
                    if apartments.isEmpty {
                        delegate?.updateConsoleTextView(withText: consolePrinter.notFound())
                    }
                    isSecondRunPlus = true
                }
            }
        }.fire()
    }
    
    //MARK: - Buttons configuration
    
    func showButtons(for apartments: [Apartment]) {
        var index = 0
        for apartment in apartments {
            guard index < Constants.maxRows * Constants.maxButtonsPerRow else { return }
            let immoButton = ImmoButton(for: apartment)
            immoButton.frame = CGRect(x: CGFloat(index % Constants.maxButtonsPerRow) * (Constants.apartButtonsWidth + Constants.spacing),
                                      y: CGFloat(index / Constants.maxButtonsPerRow) * (Constants.buttonHeight + Constants.spacing),
                                      width: Constants.immoButtonWidth,
                                      height: Constants.buttonHeight)
            
            let mapButton = MapButton(for: apartment)
            mapButton.frame = CGRect(x: CGFloat(index % Constants.maxButtonsPerRow) * (Constants.apartButtonsWidth + Constants.spacing) + Constants.immoButtonWidth + Constants.apartSpacing,
                                     y: CGFloat(index / Constants.maxButtonsPerRow) * (Constants.buttonHeight + Constants.spacing),
                                     width: Constants.mapButtonsWidth,
                                     height: Constants.buttonHeight)
            
            index += 1
            containerView?.addSubview(immoButton)
            containerView?.addSubview(mapButton)
        }
    }
    
    private func setupContainerView() {
        containerView = UIView(frame: CGRect(x: 0, y: 0,
                                             width: view.frame.width,
                                             height: CGFloat(Constants.maxRows) * (Constants.buttonHeight + Constants.spacing)))
        guard let containerView = containerView else { return }
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
             containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
             containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: (Constants.buttonHeight + Constants.spacing) * CGFloat(Constants.maxRows) - Constants.spacing)
         ])
    }
    
    private func setupStartStopButton() {
        let startStopButton = StartStopButton()
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startStopButton)
        NSLayoutConstraint.activate([
            startStopButton.widthAnchor.constraint(equalToConstant: 70),
            startStopButton.heightAnchor.constraint(equalToConstant: 70),
            startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startStopButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    //MARK: - Supporting methods
    
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
