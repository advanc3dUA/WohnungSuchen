//
//  WarningAlertControllerFactory.swift
//  WohnungSuchen
//
//  Created by Yuriy Gudimov on 02.08.2023.
//

import UIKit

class WarningAlertControllerFactory {
    func getDescription(for error: AppError) -> String {
        var description = ""
        switch error {
        case .networkManagerError(.dataUnavailable): description = "Network Manager error: data is unavailable."
        case .networkManagerError(.server(statusCode: let code)): description = "Server error: status code = \(code)."
        case .networkManagerError(.transport(let code)): description = "Transport error. Reason: \(code.localizedDescription)."
        case .immomioLinkError(.docCreationFailed): description = "ImmomioLink fetcher error: doc creation failed."
        case .immomioLinkError(.linkExtractionFailed): description = "ImmomioLink fetcher error: couldn't extract link."
        case .landlordError(.sagaDocCreationFailed): description = "Landlords error: Saga doc creation failed."
        case .landlordError(.vonoviaDecodedDataCreationFailed): description = "Landlords error: Vonovia doc creation failed."
        }
        return description
    }
}
