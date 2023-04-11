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
    var options: Options
    var currentApartments: [Apartment]
    var landlordsManager: LandlordsManager
    var soundManager: SoundManager
    var isSecondRunPlus: Bool
    var loadingView: LoadingView?
    var modalVCView: ModalView?
    
    required init?(coder aDecoder: NSCoder) {
        self.options = Options()
        self.currentApartments = [Apartment]()
        self.landlordsManager = LandlordsManager(with: options)
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
    
    private func presentModalVC() {
        modalVC = ModalVC(smallDetentSize: calcModalVCDetentSizeSmall())
        modalVC?.presentationController?.delegate = self
        modalVC?.delegate = self
        present(modalVC!, animated: true)
        modalVCView = modalVC?.view as? ModalView
    }
    
    //MARK: - Main logic
    
    func startEngine() {
        guard timer == nil else { return }
        
//        guard let modalVCView = modalVC?.view as? ModalView else { fatalError("Unable to get modalVCView in startEngine") }
        guard let modalVCView = modalVCView else { fatalError("Unable to get modalVCView in startEngine") }
        modalVCView.containerView?.isHidden = true
        updateOptions(from: modalVCView)
        soundManager.setVolume(to: options.volume)
        landlordsManager.setOptions(options)
        
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
                        self.currentApartments.insert(contentsOf: apartments, at: 0)
                        self.soundManager.playAlert(if: self.options.soundIsOn)
                        self.makeFeedback()
                    }
                }
                self.updateTableView(with: apartments.count)
                self.loadingView?.removeFromSuperview()
                self.statusLabel.text = "Last update: \(TimeManager.shared.getCurrentTime())"
                self.statusLabel.flash(numberOfFlashes: 1)
                modalVCView.containerView?.isHidden = false
                self.stopButtonIsActive(false)
            }
        }
        timer?.fire()
    }
    
    func pauseEngine() {
        timer?.invalidate()
        timer = nil
        stopButtonIsActive(true)
    }
    
    func stopEngine() {
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
        landlordsManager = LandlordsManager(with: options)
    }
    
    private func stopButtonIsActive(_ status: Bool) {
        if status {
            modalVCView?.stopButton.isEnabled = true
            modalVCView?.stopButton.alpha = 1.0
        } else {
            modalVCView?.stopButton.isEnabled = false
            modalVCView?.stopButton.alpha = 0.5
        }
    }
    
    private func updateTableView(with apartmentsNumber: Int) {
        let indexPaths = (0..<apartmentsNumber).map { index in
            IndexPath(row: index, section: 0)
        }
        self.tableView.insertRows(at: indexPaths, with: .middle)
    }
    
    //MARK: - Support functions
    
    private func updateOptions(from modalView: ModalView) {
        guard let rooms = Int(modalView.optionsView.roomsTextField.text ?? "2"),
        let area = Int(modalView.optionsView.areaTextField.text ?? "40"),
        let rent = Int(modalView.optionsView.rentTextField.text ?? "1200"),
        let updateTimer = Double(modalView.optionsView.timerUpdateTextField.text ?? "30") else { return }
        let soundIsOn = modalView.optionsView.soundSwitch.isOn
        let volume = modalView.optionsView.volumeSlider.value
        let updatedOptions = Options(rooms: rooms, area: area, rent: rent, updateTime: updateTimer, soundIsOn: soundIsOn, volume: volume)
        self.options = updatedOptions
    }
    
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
