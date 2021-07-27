//
//  HTTPError.swift
//  LogicEFT
//
//  Created by James Sayer on 7/8/21.
//

import Foundation

public enum HTTPError: Error, CustomStringConvertible {
    case nonHTTPResponse
    case requestFailed(Int)
    case serverError(Int)
    case networkError(Error)
    case custom(String)
    case decodingError(DecodingError)
    
    public var description: String {
        switch self {
        case .nonHTTPResponse:
            return "Received an invalid HTTP response status code"
        case .requestFailed(let code):
            return "Request failed with \(code) status code"
        case .serverError(let code):
            return "Encountered a server error with status code: \(code)"
        case .networkError(let error):
            return "Encountered a network error: \(error.localizedDescription)"
        case .custom(let message):
            return "Request failed with description: \(message)"
        case .decodingError(let decodingError):
            return "Encountered a data decoding error: \(decodingError.localizedDescription)"
        }
    }
}
