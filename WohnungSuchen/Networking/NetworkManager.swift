//
//  NetworkManager.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 28.03.2023.
//

import Foundation

final class NetworkManager {
    func fetchHtmlString(urlString: String, completion: @escaping (Result<String, AppError>) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let networkError = AppError.NetworkManagerError(data: data, response: response, error: error) {
                completion(.failure(AppError.networkManagerError(networkError)))
                return
            }
            let htmlString = String(decoding: data!, as: UTF8.self)
            
            completion(.success(htmlString))
        }
        task.resume()
    }
    
    func fetchData(urlString: String, completion: @escaping (Result<Data, AppError>) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let networkError = AppError.NetworkManagerError(data: data, response: response, error: error) {
                completion(.failure(AppError.networkManagerError(networkError)))
                return
            }
            completion(.success(data!))
        }
        task.resume()
    }
}
