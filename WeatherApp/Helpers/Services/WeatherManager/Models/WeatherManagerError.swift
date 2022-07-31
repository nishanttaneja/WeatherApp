//
//  WeatherManagerError.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation

struct WeatherManagerError: Error {
    let title: String
    let message: String
}

extension WeatherManagerError {
    static let cityNotFound = WeatherManagerError(title: "Server Error", message: "Unable to find your city at the moment.")
}
