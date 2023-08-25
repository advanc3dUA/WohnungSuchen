//
//  AppError.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 30.07.2023.
//

import Foundation

enum AppError: Error {
    case networkManagerError(NetworkManagerError)
    case immomioLinkError(ImmomioLinkError)
    case landlordError(LandlordsError)

    enum NetworkManagerError: Error {
        case transport(Error)
        case server(statusCode: Int)
        case dataUnavailable
    }

    enum ImmomioLinkError: Error {
        case docCreationFailed
        case linkExtractionFailed
    }

    enum LandlordsError: Error {
        case sagaDocCreationFailed
        case vonoviaDecodedDataCreationFailed
    }
}

extension AppError.NetworkManagerError {
    init?(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            self = .transport(error)
            return
        }

        if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
            self = .server(statusCode: response.statusCode)
            return
        }

        if data == nil {
            self = .dataUnavailable
        }
        return nil
    }
}
