//
//  ProvidersCollectionViewDataSource.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 16.07.2023.
//

import UIKit

extension OptionsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of landlords= \(landlordsOptions.count)")
        return landlordsOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("execution of cellForItemAt")
        let cell = self.providersCollectionView.dequeueReusableCell(withReuseIdentifier: ProvidersCollectionViewCell.identifier, for: indexPath) as! ProvidersCollectionViewCell
        let providersKeys = Array(landlordsOptions.keys)
        print("providerKeys: \(providersKeys)")
        let providersStates = Array(landlordsOptions.values)
        cell.providerButton.setTitle(providersKeys[indexPath.row], for: .normal)
        cell.providerButton.isSelected = providersStates[indexPath.row]
        cell.providerButton.addTarget(self, action: #selector(providerButtonTapped(sender:)), for: .touchUpInside)
        print("cell added with button name: \(cell.providerButton.titleLabel?.text)")
        return cell
    }
    
    @objc func providerButtonTapped(sender: UIButton) {
        print("test")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = 100
        let cellHeight = 30
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
