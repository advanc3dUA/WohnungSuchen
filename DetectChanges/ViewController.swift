//
//  ViewController.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import UIKit
import Combine

final class ViewController: UIViewController, ModalVCDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var timer: Timer?
    private var modalVC: ModalVC?
    private var modalVCIsPresented: Bool
    private var modalVCView: ModalView?
    @Published var options: Options
    @Published var currentApartments: [Apartment]
    var apartmentsDataSource: [Apartment]
    private var immomioLinkFetcher: ImmomioLinkFetcher
    private var landlordsManager: LandlordsManager?
    private var notificationsManager: NotificationsManager
    private var isSecondRunPlus: Bool
    private var loadingView: LoadingView?
    private(set) var backgroundAudioPlayer: BackgroundAudioPlayer?
    var bgAudioPlayerIsInterrupted: Bool
    
    private var cancellables: Set<AnyCancellable> = []
    
    required init?(coder aDecoder: NSCoder) {
        self.options = Options()
        self.immomioLinkFetcher = ImmomioLinkFetcher(networkManager: NetworkManager())
        self.currentApartments = [Apartment]()
        self.apartmentsDataSource = [Apartment]()
        self.notificationsManager = NotificationsManager()
        self.modalVCIsPresented = false
        self.isSecondRunPlus = false
        self.bgAudioPlayerIsInterrupted = false
        super.init(coder: aDecoder)
    }
    
    //MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colour.brandDark.setColor
        notificationsManager.requestNotificationAuthorization()
        
        backgroundAudioPlayer = BackgroundAudioPlayer(for: self)
        
        tableView.layer.cornerRadius = 10
        tableView.register(ApartmentCell.nib, forCellReuseIdentifier: ApartmentCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        setupModalVC()
        startEngine()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let modalVC = modalVC, !modalVCIsPresented {
            present(modalVC, animated: true)
            setPublisherToUpdateApartmentsDataSource()
            setNotificationManagerAlertType()
            modalVCIsPresented = true
        }
    }
    
    private func setupModalVC() {
        modalVC = ModalVC(smallDetentSize: calcModalVCDetentSizeSmall(), options: options)
        modalVC?.presentationController?.delegate = self
        modalVC?.delegate = self
        modalVCView = modalVC?.view as? ModalView
    }
    
    //MARK: - ModalVCDelegate
    
    func startEngine() {
        backgroundAudioPlayer?.start()
        landlordsManager = landlordsManager ?? LandlordsManager(immomioLinkFetcher: immomioLinkFetcher)
        guard let modalVCView = modalVCView else { fatalError("Unable to get modalVCView in startEngine") }
        modalVCView.containerView?.isHidden = true
        loadingView = LoadingView(frame: tableView.bounds)
        tableView.addSubview(loadingView!)
        
        timer = Timer.scheduledTimer(withTimeInterval: Double(options.updateTime), repeats: true) {[unowned self] timer in
            landlordsManager?.start { [weak self] apartments in
                guard let self = self else { return }
                
                if self.isSecondRunPlus && !apartments.isEmpty {
                    var modifiedApartmentsCount = 0
                    let newApartments = apartments.map { apartment in
                        if self.apartmentSatisfyCurrentFilter(apartment) {
                            var modifiedApartment = apartment
                            modifiedApartment.isNew = true
                            modifiedApartmentsCount += 1
                            return modifiedApartment
                        } else {
                            return apartment
                        }
                    }
                    self.currentApartments.insert(contentsOf: newApartments, at: 0)
                    self.notificationsManager.pushNotification(for: modifiedApartmentsCount)
                } else if !self.isSecondRunPlus {
                    self.currentApartments = apartments
                    self.isSecondRunPlus = true
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
        landlordsManager = nil
        backgroundAudioPlayer?.stop()
        bgAudioPlayerIsInterrupted = false
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
    
    private func setNotificationManagerAlertType() {
        $options
            .dropFirst()
            .sink { [unowned self] options in
                notificationsManager.setAlertType(to: options.soundIsOn ? .custom : .standart)
            }
            .store(in: &cancellables)
    }
    
    private func setPublisherToUpdateApartmentsDataSource() {
        Publishers.CombineLatest($currentApartments, $options)
            .dropFirst()
            .map { apartments, options in
                return apartments.filter { apartment in
                    self.apartmentSatisfyCurrentFilter(apartment)
                }
            }
            .sink { [unowned self] filteredApartments in
                apartmentsDataSource = filteredApartments
                tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func apartmentSatisfyCurrentFilter(_ apartment: Apartment) -> Bool {
        apartment.rooms >= options.roomsMin && apartment.rooms <= options.roomsMax &&
        apartment.area >= options.areaMin && apartment.area <= options.areaMax &&
        apartment.rent >= options.rentMin && apartment.rent <= options.rentMax
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
