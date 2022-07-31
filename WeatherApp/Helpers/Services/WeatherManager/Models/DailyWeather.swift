//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation

struct DailyWeather: Decodable {
    let DailyForecasts: [DailyForecasts]
}

struct DailyForecasts: Decodable {
    let Date: String
    let RealFeelTemperature: TemperatureRange
}

struct TemperatureRange: Decodable {
    let Minimum: Temperature
    let Maximum: Temperature
}

struct Temperature: Decodable {
    let Value: Double
}
