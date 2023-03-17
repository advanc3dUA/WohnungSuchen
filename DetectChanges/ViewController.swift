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
    
    //MARK: - VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Constants.apartButtonsWidth = (containerView.frame.width - 2 * Constants.spacing) / CGFloat(Constants.maxButtonsPerRow)
        Constants.immoButtonWidth = (Constants.apartButtonsWidth - Constants.apartSpacing) * Constants.immoButtonPercentage
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
    
    //MARK: - Buttons configuration
    
    func showButtons(for apartments: [Apartment]) {
        var index = 0
        for apartment in apartments {
            guard index < Constants.maxRows * Constants.maxButtonsPerRow else { return }
            let immoButton = ImmoButton(for: apartment)
            immoButton.frame = CGRect(x: CGFloat(index % Constants.maxButtonsPerRow) * (Constants.apartButtonsWidth + Constants.spacing),
                                      y: CGFloat(index / Constants.maxButtonsPerRow) * (Constants.buttonHeight + Constants.spacing),
                                      width: Constants.immoButtonWidth,
                                      height: Constants.buttonHeight)
            
            let mapButton = MapButton(for: apartment)
            mapButton.frame = CGRect(x: CGFloat(index % Constants.maxButtonsPerRow) * (Constants.apartButtonsWidth + Constants.spacing) + Constants.immoButtonWidth + Constants.apartSpacing,
                                     y: CGFloat(index / Constants.maxButtonsPerRow) * (Constants.buttonHeight + Constants.spacing),
                                     width: Constants.mapButtonsWidth,
                                     height: Constants.buttonHeight)
            
            index += 1
            immoButton.addTarget(self, action: #selector(immoButtonTapped(_:)), for: .touchUpInside)
            mapButton.addTarget(self, action: #selector(mapButtonTapped(_:)), for: .touchUpInside)
            containerView?.addSubview(immoButton)
            containerView?.addSubview(mapButton)
        }
    }

    @objc func immoButtonTapped(_ sender: ImmoButton) {
        guard let url = URL(string: sender.immomioLink) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func mapButtonTapped(_ sender: MapButton) {
        guard let address = sender.street.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        var urlString: String
        #if os(macOS)
            urlString = "https://www.google.com/maps/search/\(address)"
        #elseif os(iOS)
            urlString = "comgooglemaps://?q=\(address)&zoom=14"
        #endif
        print("string is: \(urlString)")
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        } else {
            DispatchQueue.main.async { [unowned self] in
                consoleTextView.text += consolePrinter.errorMakingGoogleURL()
            }
        }
    }
        
    private func setupContainerView() {
        containerView = UIView(frame: CGRect(x: 0, y: 0,
                                             width: consoleTextView.frame.width,
                                             height: CGFloat(Constants.maxRows) * (Constants.buttonHeight + Constants.spacing)))
        guard let containerView = containerView else { return }
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: consoleTextView.bottomAnchor, constant: 10),
             containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
             containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: (Constants.buttonHeight + Constants.spacing) * CGFloat(Constants.maxRows) - Constants.spacing)
         ])

    }
    
    //MARK: - Supporting methods
    
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
}
