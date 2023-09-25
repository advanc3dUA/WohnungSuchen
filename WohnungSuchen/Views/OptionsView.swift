//
//  OptionsView.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 09.04.2023.
//

import UIKit
import Combine

final class OptionsView: UIView {

    // MARK: - Views and Properties
    @IBOutlet weak private var roomsMinTextField: UITextField!
    @IBOutlet weak private var roomsMaxTextField: UITextField!
    @IBOutlet weak private var areaMinTextField: UITextField!
    @IBOutlet weak private var areaMaxTextField: UITextField!
    @IBOutlet weak private var rentMinTextField: UITextField!
    @IBOutlet weak private var rentMaxTextField: UITextField!
    @IBOutlet weak private var saveButton: SaveButton!
    @IBOutlet weak private var soundSwitch: UISwitch!
    @IBOutlet weak private var timerUpdateTextField: UITextField!
    @IBOutlet weak private var availableProvidersLabel: UILabel!
    @IBOutlet var appearanceSegmentedControl: UISegmentedControl!
    private lazy var providersCollectionView: UICollectionView = makeProvidersCollectionView()
    private(set) var optionsSubject: CurrentValueSubject<Options, Never>
    var selectedProvidersSubject: CurrentValueSubject<[Provider: Bool], Never>

    // MARK: - Initialization
    override init(frame: CGRect) {
        self.optionsSubject = CurrentValueSubject<Options, Never>(Options())
        self.selectedProvidersSubject = CurrentValueSubject<[Provider: Bool], Never>(DefaultOptions.landlords)
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        self.optionsSubject = CurrentValueSubject<Options, Never>(Options())
        self.selectedProvidersSubject = CurrentValueSubject<[Provider: Bool], Never>(DefaultOptions.landlords)
        super.init(coder: coder)
    }

    // MARK: - Setup methods
    func configure(with options: Options) {
        let defaultAttributes = [NSAttributedString.Key.foregroundColor: Color.brandDark.setColor ?? UIColor.darkGray] as [NSAttributedString.Key: Any]
        roomsMinTextField.attributedText = NSAttributedString(string: String(options.roomsMin), attributes: defaultAttributes)
        roomsMaxTextField.attributedText = NSAttributedString(string: String(options.roomsMax), attributes: defaultAttributes)
        areaMinTextField.attributedText = NSAttributedString(string: String(options.areaMin), attributes: defaultAttributes)
        areaMaxTextField.attributedText = NSAttributedString(string: String(options.areaMax), attributes: defaultAttributes)
        rentMinTextField.attributedText = NSAttributedString(string: String(options.rentMin), attributes: defaultAttributes)
        rentMaxTextField.attributedText = NSAttributedString(string: String(options.rentMax), attributes: defaultAttributes)
        timerUpdateTextField.attributedText = NSAttributedString(string: String(options.updateTime), attributes: defaultAttributes)
        soundSwitch.isOn = options.soundIsOn
        soundSwitch.set(offTint: Color.brandGray.setColor)
    }

    func setOptions(with optionsSubject: CurrentValueSubject<Options, Never>) {
        self.optionsSubject = optionsSubject
    }

    func setSelectedProviders(with selectedProvidersSubject: CurrentValueSubject<[Provider: Bool], Never>) {
        self.selectedProvidersSubject = selectedProvidersSubject
    }

    func setTargetForSaveButton(_ target: Any?, action: Selector, for event: UIControl.Event) {
        saveButton.addTarget(target, action: action, for: event)
    }

    func toggleStateOfSaveButton(_ state: Bool) {
        saveButton.toggleState(with: state)
    }

    func setSaveButtonToSelected() {
        saveButton.isSelected = true
    }

    func getProvidersCollectionViewCell(with indexPath: IndexPath) -> ProvidersCollectionViewCell? {
        providersCollectionView.dequeueReusableCell(withReuseIdentifier: ProvidersCollectionViewCell.identifier, for: indexPath) as? ProvidersCollectionViewCell
    }

    private func makeProvidersCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 30)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(ProvidersCollectionViewCell.nib, forCellWithReuseIdentifier: ProvidersCollectionViewCell.identifier)
        collectionView.backgroundColor = Color.brandOlive.setColor

        return collectionView
    }

    func setupProvidersCollectionView() {
        providersCollectionView.delegate = self
        providersCollectionView.dataSource = self

        providersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(providersCollectionView)

        NSLayoutConstraint.activate([
            providersCollectionView.heightAnchor.constraint(equalToConstant: 30),
            providersCollectionView.widthAnchor.constraint(equalToConstant: 140),
            providersCollectionView.topAnchor.constraint(equalTo: self.availableProvidersLabel.bottomAnchor, constant: 25),
            providersCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func configureAppearanceSegmentedControl(with theme: AppTheme) {
        appearanceSegmentedControl.removeAllSegments()
        appearanceSegmentedControl.insertSegment(with: UIImage(systemName: "character"), at: 0, animated: false)
        appearanceSegmentedControl.insertSegment(with: UIImage(systemName: "sun.max"), at: 1, animated: false)
        appearanceSegmentedControl.insertSegment(with: UIImage(systemName: "moon"), at: 2, animated: false)
        appearanceSegmentedControl.layer.cornerRadius = 5
        appearanceSegmentedControl.backgroundColor = Color.brandGray.setColor

        let selectedTheme: Int
        switch theme {
        case .system: selectedTheme = 0
        case .light: selectedTheme = 1
        case .dark: selectedTheme = 2
        }
        appearanceSegmentedControl.selectedSegmentIndex = selectedTheme
    }

    // MARK: - Publishers
    private func makeTextFieldIntPublisher(_ textField: UITextField, initialValue: Int) -> AnyPublisher<Int, Never> {
        textField.publisher(for: \.text)
            .map { text in
                Int(extractFrom: text, defaultValue: initialValue)
            }
            .prepend(initialValue)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func makePublisherForRoomsMinTextField() -> AnyPublisher<Int, Never> {
        makeTextFieldIntPublisher(roomsMinTextField, initialValue: optionsSubject.value.roomsMin)
    }

    func makePublisherForRoomsMaxTextField() -> AnyPublisher<Int, Never> {
        makeTextFieldIntPublisher(roomsMaxTextField, initialValue: optionsSubject.value.roomsMax)
    }

    func makePublisherForAreaMinTextField() -> AnyPublisher<Int, Never> {
        makeTextFieldIntPublisher(areaMinTextField, initialValue: optionsSubject.value.areaMin)
    }

    func makePublisherForAreaMaxTextField() -> AnyPublisher<Int, Never> {
        makeTextFieldIntPublisher(areaMaxTextField, initialValue: optionsSubject.value.areaMax)
    }

    func makePublisherForRentMinTextField() -> AnyPublisher<Int, Never> {
        makeTextFieldIntPublisher(rentMinTextField, initialValue: optionsSubject.value.rentMin)
    }

    func makePublisherForRentMaxTextField() -> AnyPublisher<Int, Never> {
        makeTextFieldIntPublisher(rentMaxTextField, initialValue: optionsSubject.value.rentMax)
    }

    func makePublisherForTimerUpdateTextField() -> AnyPublisher<Int, Never> {
        timerUpdateTextField.publisher(for: \.text)
            .map { [unowned self] textValue in
                Int(extractFrom: textValue, defaultValue: optionsSubject.value.updateTime)
            }
            .scan(nil) { previous, current in
                if current < 30 {
                    self.timerUpdateTextField.text = "30"
                    if previous == nil || previous == 30 {
                        return nil
                    } else {
                        return 30
                    }
                } else {
                    return current
                }
            }
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func makePublisherForSoundSwitch() -> AnyPublisher<Bool, Never> {
        soundSwitch.switchPublisher
            .prepend(optionsSubject.value.soundIsOn)
            .eraseToAnyPublisher()
    }

    func makePublisherForselectedProvidersSubject() -> AnyPublisher<[Provider: Bool], Never> {
        selectedProvidersSubject
            .eraseToAnyPublisher()
    }
}
