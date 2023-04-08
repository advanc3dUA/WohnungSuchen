//
//  ViewController.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, ModalVCDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var timer: Timer?
    var modalVC: ModalVC?
    var requiredApartment: Apartment
    var currentApartments: [Apartment]
    var landlordsManager: LandlordsManager
    var soundManager: SoundManager
    var isSecondRunPlus: Bool
    var loadingView: LoadingView?
    
    required init?(coder aDecoder: NSCoder) {
        self.requiredApartment = Apartment(rooms: 2, area: 40)
        self.currentApartments = [Apartment]()
        self.landlordsManager = LandlordsManager(requiredApartment: requiredApartment)
        self.soundManager = SoundManager()
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
    
    //MARK: - Main logic
    
    func startEngine() {
        guard timer == nil else { return }
        loadingView = LoadingView(frame: tableView.bounds)
        tableView.addSubview(loadingView!)
        guard let modalVCView = modalVC?.view as? ModalView else { fatalError("Unable to get modalVCView in startEngine") }
        modalVCView.containerView?.isHidden = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) {[unowned self] timer in
            landlordsManager.start { [weak self] apartments in
                guard let self = self else { return }
                if !self.isSecondRunPlus {
                    self.currentApartments = apartments
                    self.updateTableView(with: apartments.count)
                    self.isSecondRunPlus = true
                } else {
                    if !apartments.isEmpty {
                        self.currentApartments.insert(contentsOf: apartments, at: 0)
                        self.updateTableView(with: apartments.count)
                        self.soundManager.playAlert()
                        self.makeFeedback()
                    }
                    self.statusLabel.flash(numberOfFlashes: 1)
                }
                self.loadingView?.removeFromSuperview()
                self.statusLabel.text = "Last update: \(TimeManager.shared.getCurrentTime())"
                modalVCView.containerView?.isHidden = false
            }
        }
        timer?.fire()
    }
    
    func stopEngine() {
        timer?.invalidate()
        timer = nil
    }
    
    func clearTableView() {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        guard numberOfRows > 0 else {
            return
        }
        currentApartments.removeAll()
        
        var indexPaths = [IndexPath]()
        for row in 0..<numberOfRows {
            indexPaths.append(IndexPath(row: row, section: 0))
        }
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    private func updateTableView(with apartmentsNumber: Int) {
        let indexPaths = (0..<apartmentsNumber).map { index in
            IndexPath(row: index, section: 0)
        }
        self.tableView.insertRows(at: indexPaths, with: .middle)
        
    }
    
    private func presentModalVC() {
        modalVC = ModalVC(smallDetentSize: calcModalVCDetentSizeSmall())
        modalVC?.presentationController?.delegate = self
        modalVC?.delegate = self
        present(modalVC!, animated: true)
    }
    
    //MARK: - Support functions
    
    private func makeFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        let timer = Timer.scheduledTimer(withTimeInterval: 0.015, repeats: true) { timer in
            generator.prepare()
            generator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            timer.invalidate()
        }
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
