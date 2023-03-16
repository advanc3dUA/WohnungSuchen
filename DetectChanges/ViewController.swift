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
    var containerView: UIView!
    var soundManager = SoundManager()
    let networkManager = NetworkManager()
    let consolePrinter = ConsolePrinter()
    var isSecondRunPlus = false
    var buttonWidth: CGFloat!
    let buttonHeight: CGFloat = 44
    let spacing: CGFloat = 8
    let maxButtonsPerRow = 3
    let maxRows = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonWidth = (containerView.frame.width - 2 * spacing) / 3
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) {[unowned self] timer in
            networkManager.start { apartments in
                DispatchQueue.main.async { [unowned self] in
                    apartments.forEach { apartment in
                        consoleTextView.text += consolePrinter.foundNew(apartment)
                        showButtons(for: apartments) // temp
                    }
                    if isSecondRunPlus {
                        if !apartments.isEmpty {
                            soundManager.playAlert()
                            makeFeedback()
                        }
                        showButtons(for: apartments)
                    }
                    
                    if apartments.isEmpty {
                        consoleTextView.text += consolePrinter.notFound()
                    }
                    isSecondRunPlus = true
                    scrollToBottom(consoleTextView)
                }
            }
        }.fire()
    }
    
    func showButtons(for apartments: [Apartment]) {
        for apartment in apartments {
            guard let index = apartment.index else { return }
            let button = ImmoButton(type: .system)
            button.backgroundColor = .white
            button.setTitleColor(.red, for: .normal)
            button.setTitle("Apartment \(index)", for: .normal)
            button.immomioLink = apartment.immomioLink ?? "no link"
            
            button.frame = CGRect(x: CGFloat(index % maxButtonsPerRow) * (buttonWidth + spacing),
                                  y: CGFloat(index / maxButtonsPerRow) * (buttonHeight + spacing),
                                  width: buttonWidth,
                                  height: buttonHeight)
            print("button width and height: \(button.frame.width) & \(button.frame.height)")
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.tag = index
            containerView?.addSubview(button)
        }
        
        
    }

    @objc func buttonTapped(_ sender: ImmoButton) {
        guard let url = URL(string: sender.immomioLink) else { return }
        UIApplication.shared.open(url)
    }

    private func setupContainerView() {
        containerView = UIView(frame: CGRect(x: 0, y: 0,
                                             width: consoleTextView.frame.width,
                                             height: CGFloat(maxRows) * (buttonHeight + spacing)))
        guard let containerView = containerView else { return }
//        containerView.backgroundColor = .clear
        containerView.backgroundColor = .gray
        containerView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.center = view.center
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: consoleTextView.bottomAnchor, constant: 10),
             containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
             containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
             containerView.heightAnchor.constraint(equalToConstant: buttonHeight * 2 + 10)
         ])

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

