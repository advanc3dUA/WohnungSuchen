//
//  ModalVC.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 24.03.2023.
//

import UIKit
import Combine

final class ModalVC: UIViewController {

    // MARK: - Properties
    var modalView: ModalView!
    let optionsSubject: CurrentValueSubject<Options, Never>
    let selectedProvidersSubject: CurrentValueSubject<[Provider: Bool], Never>
    var currentDetent: UISheetPresentationController.Detent.Identifier? {
        didSet {
            switch currentDetent?.rawValue {
            case "com.apple.UIKit.large": modalView.showOptionsContent()
            case "small": modalView.hideOptionsContent()
            default: return
            }
        }
    }
    weak var delegate: ModalVCDelegate?
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Initialization
    init(smallDetentSize: CGFloat, optionsSubject: CurrentValueSubject<Options, Never>) {
        currentDetent = .medium
        self.optionsSubject = optionsSubject
        self.selectedProvidersSubject = CurrentValueSubject(optionsSubject.value.landlords)
        super.init(nibName: nil, bundle: nil)

        // Custom medium detent
        let smallID = UISheetPresentationController.Detent.Identifier("small")
        let smallDetent = UISheetPresentationController.Detent.custom(identifier: smallID) { _ in
            return smallDetentSize
        }
        setupSheetPresentationController(with: smallDetent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Lifecycle
    override func loadView() {
        modalView = ModalView()
        view = modalView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGasture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardInOptionsView))
        view.addGestureRecognizer(tapGasture)

        modalView.startPauseButton.addTarget(self, action: #selector(startPauseButtonTapped(sender:)), for: .touchUpInside)

        saveButtonIsEnabled(false)
        modalView.optionsView.setTargetForSaveButton(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        modalView.optionsView.updateOptionsUI(with: optionsSubject.value)
        modalView.optionsView.setOptions(with: optionsSubject)
        modalView.optionsView.setSelectedProviders(with: selectedProvidersSubject)
        setOptionsPublishers()
    }

    // MARK: - Button's actions
    func saveButtonIsEnabled(_ state: Bool) {
        modalView.optionsView.toggleStateOfSaveButton(state)
    }

    @objc func saveButtonTapped() {
        UserDefaults.standard.set(optionsSubject.value.roomsMin, forKey: SavingKeys.roomsMin.rawValue)
        UserDefaults.standard.set(optionsSubject.value.roomsMax, forKey: SavingKeys.roomsMax.rawValue)
        UserDefaults.standard.set(optionsSubject.value.areaMin, forKey: SavingKeys.areaMin.rawValue)
        UserDefaults.standard.set(optionsSubject.value.areaMax, forKey: SavingKeys.areaMax.rawValue)
        UserDefaults.standard.set(optionsSubject.value.rentMin, forKey: SavingKeys.rentMin.rawValue)
        UserDefaults.standard.set(optionsSubject.value.rentMax, forKey: SavingKeys.rentMax.rawValue)
        UserDefaults.standard.set(optionsSubject.value.updateTime, forKey: SavingKeys.updateTime.rawValue)
        UserDefaults.standard.set(optionsSubject.value.soundIsOn, forKey: SavingKeys.soundIsOn.rawValue)

        optionsSubject.value.landlords.forEach { (landlord, isActive) in
            UserDefaults.standard.set(isActive, forKey: landlord.rawValue)
        }
        saveButtonIsEnabled(false)
    }

    @objc func startPauseButtonTapped(sender: StartPauseButton) {
        if sender.isOn {
            sender.switchOff()
            delegate?.didTapStartButton()
        } else {
            sender.switchOn()
            delegate?.didTapPauseButton()
        }
    }

    // MARK: - Options publishers
    private func setOptionsPublishers() {
        let roomsMinIntPublisher = modalView.optionsView.makePublisherForRoomsMinTextField()
        let roomsMaxIntPublisher = modalView.optionsView.makePublisherForRoomsMaxTextField()
        let areaMinIntPublisher = modalView.optionsView.makePublisherForAreaMinTextField()
        let areaMaxIntPublisher = modalView.optionsView.makePublisherForAreaMaxTextField()
        let rentMinIntPublisher = modalView.optionsView.makePublisherForRentMinTextField()
        let rentMaxIntPublisher = modalView.optionsView.makePublisherForRentMaxTextField()
        let timerUpdateIntPublisher = modalView.optionsView.makePublisherForTimerUpdateTextField()
        let soundSwitchPublisher = modalView.optionsView.makePublisherForSoundSwitch()
        let selectedProvidersPublisher = modalView.optionsView.makePublisherForselectedProvidersSubject()

        let roomsPub = Publishers.CombineLatest(roomsMinIntPublisher, roomsMaxIntPublisher)
        let areaPub = Publishers.CombineLatest(areaMinIntPublisher, areaMaxIntPublisher)
        let rentPub = Publishers.CombineLatest(rentMinIntPublisher, rentMaxIntPublisher)
        let updateTimeSoundSwitchAndSelectedProvidersPub = Publishers.CombineLatest3(timerUpdateIntPublisher, soundSwitchPublisher, selectedProvidersPublisher)
        let options = Options()

        Publishers.CombineLatest4(roomsPub, areaPub, rentPub, updateTimeSoundSwitchAndSelectedProvidersPub)
            .dropFirst()
            .map { rooms, area, rent, updateTimeSoundSwitchAndProviders in
                options.roomsMin = rooms.0
                options.roomsMax = rooms.1
                options.areaMin = area.0
                options.areaMax = area.1
                options.rentMin = rent.0
                options.rentMax = rent.1
                options.updateTime = updateTimeSoundSwitchAndProviders.0
                options.soundIsOn = updateTimeSoundSwitchAndProviders.1
                options.landlords.forEach { (landlord, _) in
                    options.landlords[landlord] = updateTimeSoundSwitchAndProviders.2[landlord]
                }
                return rooms.0 <= rooms.1 && area.0 <= area.1 && rent.0 <= rent.0
            }
            .sink { [unowned self] isValid in
                saveButtonIsEnabled(isValid)
                if options.isEqualToUserDefaults() {
                    saveButtonIsEnabled(false)
                }
                optionsSubject.value = options
            }
            .store(in: &cancellables)
    }

    // MARK: - Supporting methods
    private func setupSheetPresentationController(with smallDetent: UISheetPresentationController.Detent) {
        sheetPresentationController?.detents = [smallDetent, .large()]
        sheetPresentationController?.largestUndimmedDetentIdentifier = .large
        sheetPresentationController?.prefersScrollingExpandsWhenScrolledToEdge = true
        sheetPresentationController?.prefersEdgeAttachedInCompactHeight = true
        sheetPresentationController?.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.preferredCornerRadius = 10

        // Disables hiding TraineeVC
        isModalInPresentation = true
    }

    @objc private func hideKeyboardInOptionsView() {
        hideKeyboardIfViewIsTextField(in: modalView.optionsView)
    }

    private func hideKeyboardIfViewIsTextField(in view: UIView) {
        for subview in view.subviews {
            if subview is UITextField {
                subview.resignFirstResponder()
            } else {
                hideKeyboardIfViewIsTextField(in: subview)
            }
        }
    }
}
