//
//  ErrorResponse.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 31/5/22.
//

import Foundation

enum ErrorResponse: String {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError

    var description: String {
        switch self {
        case .apiError: return NSLocalizedString("apiKey_error", comment: "")
        case .invalidEndpoint: return NSLocalizedString("invalid_endpoint", comment: "")
        case .invalidResponse: return NSLocalizedString("invalid_response", comment: "")
        case .noData: return NSLocalizedString("no_data", comment: "")
        case .serializationError: return NSLocalizedString("serialization_error", comment: "")
        }
    }
}
