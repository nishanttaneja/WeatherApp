//
//  APIServiceError.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation

struct APIServiceError: Error {
    let title: String
    let message: String
}

extension APIServiceError {
    static let invalidUrl = APIServiceError(title: "Invalid Request", message: "Try again later.")
    static let unableToFetchData = APIServiceError(title: "Server Error", message: "some error occurred")
    static func didFail(with error: Error) -> APIServiceError {
        APIServiceError(title: "unknown error", message: error.localizedDescription)
    }
}
