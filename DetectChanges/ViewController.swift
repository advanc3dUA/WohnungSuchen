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
    
    var apartButtonsWidth: CGFloat!
    var immoButtonWidth: CGFloat! {
        didSet {
            mapButtonsWidth = (apartButtonsWidth - apartSpacing) - immoButtonWidth
        }
    }
    var mapButtonsWidth: CGFloat!
    var immoButtonPercentage: Double = 0.75
    
    let buttonHeight: CGFloat = 44
    let spacing: CGFloat = 8
    let apartSpacing: CGFloat = 4
    let maxButtonsPerRow = 3
    let maxRows = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        apartButtonsWidth = (containerView.frame.width - 2 * spacing) / 3
        immoButtonWidth = (apartButtonsWidth - apartSpacing) * immoButtonPercentage
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) {[unowned self] timer in
            networkManager.start { apartments in
                DispatchQueue.main.async { [unowned self] in
                    apartments.forEach { apartment in
                        consoleTextView.text += consolePrinter.foundNew(apartment)
                    }
                    showButtons(for: apartments) // temp?
                    if isSecondRunPlus {
                        if !apartments.isEmpty {
                            containerView.removeAllSubviews()
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
        var index = 0
        for apartment in apartments {
            let immoButton = ImmoButton(for: apartment)
            immoButton.frame = CGRect(x: CGFloat(index % maxButtonsPerRow) * (apartButtonsWidth + spacing),
                                  y: CGFloat(index / maxButtonsPerRow) * (buttonHeight + spacing),
                                  width: immoButtonWidth,
                                  height: buttonHeight)
            
            let mapButton = MapButton(for: apartment)
            mapButton.frame = CGRect(x: CGFloat(index % maxButtonsPerRow) * (apartButtonsWidth + spacing) + immoButtonWidth + apartSpacing,
                                     y: CGFloat(index / maxButtonsPerRow) * (buttonHeight + spacing),
                                     width: mapButtonsWidth,
                                     height: buttonHeight)
            
            index += 1
            immoButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            mapButton.addTarget(self, action: #selector(mapButtonTapped(_:)), for: .touchUpInside)
            containerView?.addSubview(immoButton)
            containerView?.addSubview(mapButton)
        }
    }

    @objc func buttonTapped(_ sender: ImmoButton) {
        guard let url = URL(string: sender.immomioLink) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func mapButtonTapped(_ sender: MapButton) {
        let urlString = "https://maps.apple.com/?q=\(sender.street)"
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
        
    private func setupContainerView() {
        containerView = UIView(frame: CGRect(x: 0, y: 0,
                                             width: consoleTextView.frame.width,
                                             height: CGFloat(maxRows) * (buttonHeight + spacing)))
        guard let containerView = containerView else { return }
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
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

