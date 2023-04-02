//
//  NetworkManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 28.03.2023.
//

import Foundation

class NetworkManager {
    func fetchHtmlString(urlString: String, completion: @escaping (String?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            let htmlString = String(decoding: data, as: UTF8.self)
            
            completion(htmlString)
        }
        task.resume()
    }
    
    func fetchData(urlString: String, completion: @escaping (Data) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            completion(data)
        }
        task.resume()
    }
}
