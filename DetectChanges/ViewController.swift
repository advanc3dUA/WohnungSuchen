//
//  ViewController.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 10.03.2023.
//

import UIKit
import AVFoundation
import CoreHaptics

class ViewController: UIViewController {
    @IBOutlet weak var consoleTextView: UITextView!
    var soundManager = SoundManager()
    let networkManager = NetworkManager()
    let consolePrinter = ConsolePrinter()
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
                            makeFeedback()
                            guard let immomioLink = apartment.immomioLink, let url = URL(string: immomioLink) else { return }
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    if apartments.isEmpty {
                        consoleTextView.text += consolePrinter.notFound()
                    }
                    isFirstRun = false
                    scrollToBottom(consoleTextView)
                }
            }
        }.fire()
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
    
    func makeFeedback() {
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

