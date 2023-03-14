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
    var immomioLinks: [String] = []
    
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
//                    if !isFirstRun {
//                        apartments.forEach { apartment in
//                            soundManager.playAlert()
//                            makeFeedback()
//                            guard let immomioLink = apartment.immomioLink, let url = URL(string: immomioLink) else { return }
//                            UIApplication.shared.open(url)
//                        }
//                    }
//                    if !isFirstRun {
                    if isFirstRun {
                        soundManager.playAlert()
                        makeFeedback()
                        var immomioLinks = [String]()
                        apartments.forEach { apartment in
                            guard let immomioLink = apartment.immomioLink else { return }
                            immomioLinks.append(immomioLink)
                        }
                        showButtons(immomioLinks)
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
    
    func showButtons(_ immomioLinks: [String]) {
        self.immomioLinks = immomioLinks
        
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 44
        let spacing: CGFloat = 8
        let maxButtonsPerRow = 3
        let maxRows = 2
        
        let buttonCount = min(immomioLinks.count, maxButtonsPerRow * maxRows)
        let rowCount = min((buttonCount + maxButtonsPerRow - 1) / maxButtonsPerRow, maxRows)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(maxButtonsPerRow) * (buttonWidth + spacing), height: CGFloat(rowCount) * (buttonHeight + spacing)))
        containerView.backgroundColor = .clear
        
        for (index, immomioLink) in immomioLinks.prefix(buttonCount).enumerated() {
            let button = UIButton(type: .system)
            button.setTitle("Button \(index+1)", for: .normal)
            button.frame = CGRect(x: CGFloat(index % maxButtonsPerRow) * (buttonWidth + spacing),
                                  y: CGFloat(index / maxButtonsPerRow) * (buttonHeight + spacing),
                                  width: buttonWidth,
                                  height: buttonHeight)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.tag = index
            containerView.addSubview(button)
        }
        
        view.addSubview(containerView)
        containerView.center = view.center
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let immomioLink = immomioLinks[sender.tag]
        guard let url = URL(string: immomioLink) else { return }
        UIApplication.shared.open(url)
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

