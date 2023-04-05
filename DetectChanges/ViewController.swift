//
//  ViewController.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var consoleTextView: UITextView!
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
        setupConsoleTextView()
        
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) {[unowned self] timer in
            
            landlordsManager.start { apartments in
                if !self.isSecondRunPlus {
                    self.currentApartments = apartments
                }
                
            }
            
            
            
            
            
            
            
//            landlordsManager.start { apartments in
//                DispatchQueue.main.async { [unowned self] in
//                    apartments.forEach { apartment in
//                        consoleTextView.text += ConsolePrinter.shared.foundNew(apartment)
//                        print("found new: \(apartment.street)")
//                    }
////                    modalView.buttonsContainerView.showButtons(for: apartments)
//                    if isSecondRunPlus {
//                        if !apartments.isEmpty {
////                            modalView.buttonsContainerView.removeAllSubviews()
//                            soundManager.playAlert()
//                            makeFeedback()
//                        }
////                        modalView.buttonsContainerView.showButtons(for: apartments)
//                    }
//
//                    if apartments.isEmpty {
//                        consoleTextView.text += ConsolePrinter.shared.notFound()
//                    }
//                    isSecondRunPlus = true
//                }
//            }
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
    
//    private func setupTableView() {
//        let height = view.frame.height * 0.9
//        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: height))
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
    
    private func setupConsoleTextView() {
        consoleTextView.layer.cornerRadius = 20
        consoleTextView.textColor = .black
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
        consoleTextView.text += text
        scrollToBottom(consoleTextView)
    }
}
