//
//  ViewController.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import UIKit
import Combine

class ViewController: UIViewController, ModalVCDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var timer: Timer?
    var modalVC: ModalVC?
    @Published var options: Options
    @Published var currentApartments: [Apartment]
    var apartmentsDataSource: [Apartment]
    var landlordsManager: LandlordsManager
    var feedbackManager: FeedbackManager
    var isSecondRunPlus: Bool
    var loadingView: LoadingView?
    var modalVCView: ModalView?
    
    private var cancellables: Set<AnyCancellable> = []
    
    required init?(coder aDecoder: NSCoder) {
        self.options = Options()
        self.currentApartments = [Apartment]()
        self.apartmentsDataSource = [Apartment]()
        self.landlordsManager = LandlordsManager()
        self.feedbackManager = FeedbackManager()
        self.isSecondRunPlus = false
        super.init(coder: aDecoder)
    }
    
    //MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colour.brandDark.setColor
        
        tableView.layer.cornerRadius = 10
        tableView.register(ApartmentCell.nib, forCellReuseIdentifier: ApartmentCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentModalVC()
        startEngine()
    }
    
    private func presentModalVC() {
        modalVC = ModalVC(smallDetentSize: calcModalVCDetentSizeSmall())
        modalVC?.presentationController?.delegate = self
        modalVC?.delegate = self
        present(modalVC!, animated: true)
        modalVCView = modalVC?.view as? ModalView
    }
    
    //MARK: - ModalVCDelegate
    
    func startEngine() {
        guard let modalVCView = modalVCView else { fatalError("Unable to get modalVCView in startEngine") }
        modalVCView.containerView?.isHidden = true
        setPublishersToUpdateOptions(from: modalVCView)
        setPublisherToUpdateApartmentsDataSource()
        loadingView = LoadingView(frame: tableView.bounds)
        tableView.addSubview(loadingView!)
        
        timer = Timer.scheduledTimer(withTimeInterval: options.updateTime, repeats: true) {[unowned self] timer in
            landlordsManager.start { [weak self] apartments in
                guard let self = self else { return }
                
                if !self.isSecondRunPlus {
                    self.currentApartments = apartments
                    self.isSecondRunPlus = true
                } else {
                    if !apartments.isEmpty {
                        
                        let newApartments = apartments.map {
                            Apartment(time: $0.time, title: $0.title, internalLink: $0.internalLink, street: $0.street, rooms: $0.rooms, area: $0.area, rent: $0.rent, externalLink: $0.externalLink, company: $0.company, isNew: true)
                        }
                        
                        self.currentApartments.insert(contentsOf: newApartments, at: 0)
                        self.feedbackManager.makeFeedback()
                    }
                }
                self.loadingView?.removeFromSuperview()
                self.statusLabel.text = "Last update: \(TimeManager.shared.getCurrentTime())"
                self.statusLabel.flash(numberOfFlashes: 1)
                modalVCView.containerView?.isHidden = false
                self.enableStopButton(false)
            }
        }
        timer?.fire()
    }
    
    func pauseEngine() {
        timer?.invalidate()
        timer = nil
        enableStopButton(true)
    }
    
    func stopEngine() {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        guard numberOfRows > 0 else {
            return
        }
        apartmentsDataSource.removeAll()
        
        var indexPaths = [IndexPath]()
        for row in 0..<numberOfRows {
            indexPaths.append(IndexPath(row: row, section: 0))
        }
        tableView.deleteRows(at: indexPaths, with: .automatic)
        isSecondRunPlus = false
        landlordsManager = LandlordsManager()
    }
    
    func updateSoundManagerAlertType(with status: Bool) {
        guard let modalView = modalVCView else { return }
        feedbackManager.setAlertType(to: modalView.optionsView.soundSwitch.isOn ? .sound : .vibration)
    }
    
    func updateSoundManagerVolume(with value: Float) {
        guard let modalView = modalVCView else { return }
        feedbackManager.setVolume(to: modalView.optionsView.volumeSlider.value)
    }
    
    //MARK: - Support functions
    private func enableStopButton(_ status: Bool) {
        if status {
            modalVCView?.stopButton.isEnabled = true
            modalVCView?.stopButton.alpha = 1.0
        } else {
            modalVCView?.stopButton.isEnabled = false
            modalVCView?.stopButton.alpha = 0.5
        }
    }
    
    private func setPublishersToUpdateOptions(from modalView: ModalView) {
        modalView.optionsView.roomsTextField.publisher(for: \.text)
            .map { Int(extractFrom: $0, defaultValue: Constants.defaultOptions.rooms) }
            .sink { [weak self] in
                guard let self = self else { return }
                self.options.rooms = $0
            }
            .store(in: &cancellables)
        
        modalView.optionsView.areaTextField.publisher(for: \.text)
            .map { Int(extractFrom: $0, defaultValue: Constants.defaultOptions.area) }
            .sink { [weak self] in
                guard let self = self else { return }
                self.options.area = $0
            }
            .store(in: &cancellables)
        
        modalView.optionsView.rentTextField.publisher(for: \.text)
            .map { Int(extractFrom: $0, defaultValue: Constants.defaultOptions.rent) }
            .sink { [weak self] in
                guard let self = self else { return }
                self.options.rent = $0
            }
            .store(in: &cancellables)
        
        modalView.optionsView.timerUpdateTextField.publisher(for: \.text)
            .map { Double(extractFrom: $0, defaultValue: Constants.defaultOptions.updateTimer) }
            .sink { [weak self] in
                guard let self = self else { return }
                self.options.updateTime = $0
            }
            .store(in: &cancellables)
    }
    
    private func setPublisherToUpdateApartmentsDataSource() {
        Publishers.CombineLatest($currentApartments, $options)
            .map { apartments, options in
                apartments.filter { apartment in
                    apartment.rooms >= options.rooms && apartment.area >= options.area && apartment.rent <= options.rent
                }
            }
            .sink { [unowned self] filteredApartments in
                apartmentsDataSource = filteredApartments
                tableView.reloadData()
            }
            .store(in: &cancellables)
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
    
    private func calcModalVCDetentSizeSmall() -> CGFloat {
        self.view.frame.height * 0.1
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
