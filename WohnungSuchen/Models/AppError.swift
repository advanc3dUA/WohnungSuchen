//
//  AppError.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 30.07.2023.
//

import Foundation

enum AppError: Error {
    enum NetworkManagerError: Error {
        case transportError(Error)
        case serverError(statusCode: Int)
        case dataUnavailable
    }
    
    enum ImmomioLinkError: Error {

    }
}

extension AppError.NetworkManagerError {
    init?(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            self = .transportError(error)
            return
        }
        
        if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
            self = .serverError(statusCode: response.statusCode)
            return
        }
        
        if data == nil {
            self = .dataUnavailable
        }
        return nil
    }
}
