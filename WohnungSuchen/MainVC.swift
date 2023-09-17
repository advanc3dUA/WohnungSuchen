//
//  MainVC.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import UIKit
import Combine

final class MainVC: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var statusLabel: StatusLabel!
    @IBOutlet weak var tableView: UITableView!
    private var timer: Timer?
    private var modalVC: ModalVC?
    private var modalVCIsPresented: Bool
    private var modalVCView: ModalView?
    private var optionsSubject: CurrentValueSubject<Options, Never>
    @Published var currentApartments: [Apartment]
    var apartmentsDataSource: [Apartment]
    private var immomioLinkFetcher: ImmomioLinkFetcher
    private var landlordsManager: LandlordsManager?
    private var notificationsManager: NotificationsManager
    private var isSecondRunPlus: Bool
    private lazy var loadingView: LoadingView = makeLoadingView()
    private(set) var backgroundAudioPlayer: BackgroundAudioPlayer?
    private var warningAlertControllerFactory: WarningAlertControllerFactory
    var bgAudioPlayerIsInterrupted: Bool
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        let savedDefaultOptions = Options()
        savedDefaultOptions.loadSavedDefaults()
        self.optionsSubject = CurrentValueSubject<Options, Never>(savedDefaultOptions)
        self.immomioLinkFetcher = ImmomioLinkFetcher(networkManager: NetworkManager())
        self.currentApartments = [Apartment]()
        self.apartmentsDataSource = [Apartment]()
        self.notificationsManager = NotificationsManager()
        self.warningAlertControllerFactory = WarningAlertControllerFactory()
        self.modalVCIsPresented = false
        self.isSecondRunPlus = false
        self.bgAudioPlayerIsInterrupted = false
        super.init(coder: aDecoder)
    }

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsManager.requestNotificationAuthorization()

        backgroundAudioPlayer = BackgroundAudioPlayer(for: self)
        backgroundAudioPlayer?.start()

        setupMainView()
        setupTableView()

        landlordsManager = LandlordsManager()
        setPublisherToUpdateLandlordsListInManager()

        setupModalVC()
        guard let modalVCView = modalVCView else { fatalError("Unable to get modalVCView in startEngine") }
        modalVCView.containerView?.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let modalVC = modalVC, !modalVCIsPresented {
            present(modalVC, animated: true)
            setPublisherForApartmentsDataSource()
            setPublisherForNotificationAlertType()
            setPublisherForTimerInterval()
            modalVCIsPresented = true
        }
    }

    // MARK: - Start/Stop Engine
    func startEngine() {
        tableView.addSubview(loadingView)
        timer = Timer.scheduledTimer(withTimeInterval: Double(optionsSubject.value.updateTime), repeats: true) {[unowned self] _ in
            landlordsManager?.start { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .failure(let error):
                    let errorDescription = warningAlertControllerFactory.getDescription(for: error)
                    DispatchQueue.main.async { [unowned modalVC] in
                        let warningController = UIAlertController(title: "Warning", message: errorDescription, preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .cancel)
                        warningController.addAction(okButton)
                        modalVC?.present(warningController, animated: true)
                        self.statusLabel.update(receivedError: true)
                    }

                case .success(let apartments):
                    if self.isSecondRunPlus && !apartments.isEmpty {
                        var modifiedApartmentsCount = 0
                        let newApartments = apartments.map { apartment in
                            if self.checkApartmentSatisfyCurrentFilter(apartment) {
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
                    self.statusLabel.update(receivedError: false)
                    modalVCView?.containerView?.isHidden = false
                }
                DispatchQueue.main.async {
                    self.loadingView.removeFromSuperview()
                }
            }
        }
        timer?.fire()
    }

    func pauseEngine() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Publishers
    private func setPublisherToUpdateLandlordsListInManager() {
        optionsSubject
            .map { $0.landlords }
            .removeDuplicates()
            .sink { [unowned self] landlords in
                guard let activeProviders = landlordsManager?.landlords else {
                    fatalError("Error in setPublisherToUpdateLandlordsListInManager")
                }
                landlords.forEach { (landlord, isActive) in
                    let isAlreadyAdded = activeProviders.contains(where: { $0.name == landlord })
                    if isActive && !isAlreadyAdded {
                        let newProvider = Provider.generateProvider(with: landlord)
                        landlordsManager?.landlords.append(newProvider)
                    } else if !isActive && isAlreadyAdded {
                        landlordsManager?.landlords.removeAll(where: { $0.name == landlord })
                        landlordsManager?.previousApartments.removeAll(where: { apartment in
                            apartment.landlord.name == landlord
                        })
                        currentApartments.removeAll(where: { $0.landlord.name == landlord })
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func setPublisherForNotificationAlertType() {
        optionsSubject
            .dropFirst()
            .sink { [unowned self] options in
                notificationsManager.setAlertType(to: options.soundIsOn ? .custom : .standart)
            }
            .store(in: &cancellables)
    }

    private func setPublisherForTimerInterval() {
        optionsSubject
            .map { currentOptions -> Int in
                return currentOptions.updateTime
            }
            .removeDuplicates()
            .scan(nil) { (previous: Int?, current: Int) -> Int? in
                if previous != current {
                    return current
                } else {
                    return nil
                }
            }
            .compactMap { $0 }
            .sink { [unowned self] _ in
                pauseEngine()
                startEngine()
            }
            .store(in: &cancellables)
    }

    private func setPublisherForApartmentsDataSource() {
        Publishers.CombineLatest($currentApartments, optionsSubject)
            .dropFirst()
            .map { apartments, _ in
                return apartments.filter { apartment in
                    self.checkApartmentSatisfyCurrentFilter(apartment)
                }
            }
            .sink { [unowned self] filteredApartments in
                apartmentsDataSource = filteredApartments
                tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    // MARK: - Support methods
    private func setupMainView() {
        view.backgroundColor = Color.brandDark.setColor
    }

    private func setupModalVC() {
        modalVC = ModalVC(smallDetentSize: calcModalVCDetentSizeSmall(), optionsSubject: optionsSubject)
        modalVC?.presentationController?.delegate = self
        modalVC?.delegate = self
        modalVCView = modalVC?.view as? ModalView
    }

    private func setupTableView() {
        tableView.layer.cornerRadius = 10
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.register(ApartmentCell.nib, forCellReuseIdentifier: ApartmentCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func makeLoadingView() -> LoadingView {
        LoadingView(frame: tableView.bounds)
    }

    private func checkApartmentSatisfyCurrentFilter(_ apartment: Apartment) -> Bool {
        apartment.rooms >= optionsSubject.value.roomsMin && apartment.rooms <= optionsSubject.value.roomsMax &&
        apartment.area >= optionsSubject.value.areaMin && apartment.area <= optionsSubject.value.areaMax &&
        apartment.rent >= optionsSubject.value.rentMin && apartment.rent <= optionsSubject.value.rentMax
    }
}

// MARK: - DetectDetent Protocol
extension MainVC: DetectDetent {
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

// MARK: - UISheetPresentationControllerDelegate
extension MainVC: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        if let currentDetent = sheetPresentationController.selectedDetentIdentifier {
            detentChanged(detent: currentDetent)
        }
    }
}
