//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation

struct CurrentWeather: Decodable {
    let WeatherText: String
    let Temperature: RealFeelTemperature
    let TemperatureSummary: TemperatureSummary
}

struct RealFeelTemperature: Decodable {
    let Metric: Temperature
}

struct TemperatureSummary: Decodable {
    let Past6HourRange: PastHourTemperature
}

struct PastHourTemperature: Decodable {
    let Minimum: RealFeelTemperature
    let Maximum: RealFeelTemperature
}
