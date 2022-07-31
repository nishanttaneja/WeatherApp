//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

struct CurrentWeather: Decodable {
    let WeatherText: String
    let WeatherIcon: Int
    let Temperature: RealFeelTemperature
    let TemperatureSummary: TemperatureSummary
}

extension CurrentWeather {
    var image: UIImage? {
        UIImage(named: "\(WeatherIcon)")
    }
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
