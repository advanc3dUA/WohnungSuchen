//
//  ProvidersCollectionViewDataSource.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 16.07.2023.
//

import UIKit

extension OptionsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfProviders = optionsSubject?.value.landlords.count {
            return numberOfProviders
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.providersCollectionView.dequeueReusableCell(withReuseIdentifier: ProvidersCollectionViewCell.identifier, for: indexPath) as! ProvidersCollectionViewCell
        guard let landlords = optionsSubject?.value.landlords else { return cell }
        let providersKeys = Array(landlords.keys)
        let providersStates = Array(landlords.values)
        cell.providerButton.setTitle(providersKeys[indexPath.row], for: .normal)
        cell.providerButton.isSelected = providersStates[indexPath.row]
        
        cell.providerButton.layer.borderColor = Colour.brandDark.setColor?.cgColor
        let normalbackgroundColor = cell.providerButton.imageWithColor(Colour.brandDark.setColor ?? .clear)
        cell.providerButton.setBackgroundImage(normalbackgroundColor, for: .normal)
        
        let selectedbackgroundColor = cell.providerButton.imageWithColor(Colour.brandBlue.setColor ?? .clear)
        cell.providerButton.setBackgroundImage(selectedbackgroundColor, for: .selected)
        
//        cell.providerButton.isHighlighted = true
        
        cell.providerButton.addTarget(self, action: #selector(providerButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func providerButtonTapped(sender: UIButton) {
        guard let title = sender.currentTitle else {
            print("Error getting the name of providerButton")
            return
        }
        
        print("Click")
        sender.isSelected.toggle()
        
        optionsSubject?.value.landlords[title] = sender.isSelected
        print("Landlord \(title) is set to \(sender.isSelected)")
        
        if let options = optionsSubject?.value {
            optionsSubject?.send(options)
        }
    }

    
//    @objc func providerButtonTapped(sender: UIButton) {
//        guard let title = sender.currentTitle else {
//            print("error getting the name of providerButton")
//            return
//        }
//        print("click")
//        sender.isSelected = !sender.isSelected
//        let options = Options()
//        options.areaMax = optionsSubject!.value.areaMax
//        options.areaMin = optionsSubject!.value.areaMin
//        options.rentMin = optionsSubject!.value.rentMin
//        options.rentMax = optionsSubject!.value.rentMax
//        options.roomsMin = optionsSubject!.value.roomsMin
//        options.roomsMax = optionsSubject!.value.roomsMax
//        options.soundIsOn = optionsSubject!.value.soundIsOn
//        options.updateTime = optionsSubject!.value.updateTime
//        options.landlords[title] = sender.isSelected
//        print("landlord \(title) is set to \(sender.isSelected)")
//        optionsSubject?.send(options)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = 100
        let cellHeight = 30
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
