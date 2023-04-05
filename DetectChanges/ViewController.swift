//
//  ViewController.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var modalVC: ModalVC?
    var requiredApartment: Apartment
    var currentApartments: [Apartment] {
        didSet {
            tableView.reloadData()
        }
    }
    var landlordsManager: LandlordsManager
    var soundManager: SoundManager
    var isSecondRunPlus: Bool
    
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
        view.backgroundColor = .black
        
        tableView.register(ApartmentCell.nib, forCellReuseIdentifier: ApartmentCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentModalVC()
        
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) {[unowned self] timer in
            statusLabel.text = "Last update: \(postTime())"
            landlordsManager.start { [weak self] apartments in
                guard let self = self else { return }
                if !self.isSecondRunPlus {
                    self.currentApartments = apartments
                    self.isSecondRunPlus = true
                } else {
                    if !apartments.isEmpty {
                        self.currentApartments.insert(contentsOf: apartments, at: 0)
                        self.soundManager.playAlert()
                        self.makeFeedback()
                    }
                }
            }
        }.fire()
    }
    
    private func presentModalVC() {
        modalVC = ModalVC(mediumDetentSize: calcModalVCDetentSizeMedium())
        modalVC?.presentationController?.delegate = self
        modalVC?.delegate = self
        present(modalVC!, animated: true)
    }
    
    private func scrollToBottom(_ textView: UITextView) {
        guard !textView.text.isEmpty else { return }
        let range = NSMakeRange(textView.text.count - 1, 1)
        textView.scrollRangeToVisible(range)
        let bottomOffset = CGPoint(x: 0, y: textView.contentSize.height - textView.frame.height)
        if bottomOffset.y > 0 {
            textView.setContentOffset(bottomOffset, animated: true)
        }
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
    
    private func postTime() -> String {
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: currentTime)
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
    
    private func calcModalVCDetentSizeMedium() -> CGFloat {
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

//MARK: - ModalVCDelegate
extension ViewController: ModalVCDelegate {
    func updateConsoleTextView(_ text: String) {
//        consoleTextView.text += text
//        scrollToBottom(consoleTextView)
    }
}
