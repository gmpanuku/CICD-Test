//
//  NetworkError.swift
//  Qubicash
//
//  Created by Panuku Goutham on 07/04/22.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidRequest
    case invalidParameters
    case nilSearchKeyOrSearchText
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .invalidRequest:
            return NSLocalizedString("Invalid request", comment: "Invalid request")
        case .invalidParameters:
            return NSLocalizedString("Invalid parameters", comment: "Invalid parameters")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .nilSearchKeyOrSearchText:
            return NSLocalizedString("Search key or Search text is nil/empty", comment: "Search key or Search text is nil/empty")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
