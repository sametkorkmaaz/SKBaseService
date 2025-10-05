//
//  NetworkError.swift
//  SKBaseService
//
//  Created by Samet Korkmaz on 5.10.2025.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case invalidStatusCode(Int)
    case noData
    case decodingFailed(Error)
    case unknownError

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .requestFailed(let error):
            return "The network request failed. Original error: \(error.localizedDescription)"
        case .invalidResponse:
            return "The server returned an invalid response."
        case .invalidStatusCode(let statusCode):
            return "The request returned an invalid status code: \(statusCode)."
        case .noData:
            return "The request returned no data."
        case .decodingFailed(let error):
            return "Failed to decode the response. Original error: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
