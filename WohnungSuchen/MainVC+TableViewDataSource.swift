//
//  MainVC+TableViewDataSource.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 20.09.2023.
//

import UIKit

extension MainVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apartmentsDataSource.count
    }
}
