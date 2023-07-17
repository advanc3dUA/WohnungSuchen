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
        cell.providerButton.setTitle(providersKeys[indexPath.row], for: .highlighted)
        cell.providerButton.isSelected = providersStates[indexPath.row]
        
        cell.providerButton.addTarget(self, action: #selector(providerButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func providerButtonTapped(sender: UIButton) {
        guard let title = sender.currentTitle else {
            print("Error getting the name of providerButton")
            return
        }
        sender.isSelected.toggle()
        
        optionsSubject?.value.landlords[title] = sender.isSelected
        
        if let options = optionsSubject?.value {
            optionsSubject?.send(options)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = 65
        let cellHeight = 30
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
