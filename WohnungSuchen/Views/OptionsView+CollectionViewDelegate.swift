//
//  OptionsView+CollectionViewDelegate.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 16.07.2023.
//

import UIKit

extension OptionsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        optionsSubject.value.landlords.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = getProvidersCollectionViewCell(with: indexPath) else {
            return UICollectionViewCell()
        }
        let landlords = optionsSubject.value.landlords
        let providersKeys = Array(landlords.keys)
        let providersStates = Array(landlords.values)
        cell.configure(title: providersKeys[indexPath.row].rawValue, isSelected: providersStates[indexPath.row])
        cell.setProviderButtonTarget(self, action: #selector(providerButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }

    @objc func providerButtonTapped(sender: UIButton) {
        guard let title = sender.currentTitle else {
            print("Error getting the name of providerButton")
            return
        }
        sender.isSelected.toggle()

        if let provider = Provider.getProvider(from: title) {
            var updatedProviders = optionsSubject.value.landlords
            updatedProviders[provider] = sender.isSelected
            selectedProvidersSubject.send(updatedProviders)
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
