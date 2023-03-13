//
//  ViewController.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var consoleTextView: UITextView!
    var soundManager = SoundManager()
    let networkManager = NetworkManager()
    let consolePrinter = ConsolePrinter()
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var isFirstRun = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) {[unowned self] timer in
            networkManager.start { apartments in
                DispatchQueue.main.async { [unowned self] in
                    apartments.forEach { apartment in
                        consoleTextView.text += consolePrinter.foundNew(apartment)
                    }
                    if !isFirstRun {
                        apartments.forEach { apartment in
                            soundManager.playAlert()
                            feedbackGenerator.impactOccurred()
                            guard let immomioLink = apartment.immomioLink, let url = URL(string: immomioLink) else { return }
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    if apartments.isEmpty {
                        consoleTextView.text += consolePrinter.notFound()
                    }
                    isFirstRun = false
                    scrollConsoleToBottom()
                }
            }
        }.fire()
    }
    
    private func scrollConsoleToBottom() {
        let range = NSMakeRange(consoleTextView.text.count - 1, 1)
        consoleTextView.scrollRangeToVisible(range)
    }
}

