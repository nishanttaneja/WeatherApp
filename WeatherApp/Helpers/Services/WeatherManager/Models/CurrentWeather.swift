//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation

struct CurrentWeather: Decodable {
    let WeatherText: String
    let RealFeelTemperature: RealFeelTemperature
}

struct RealFeelTemperature: Decodable {
    let Metric: Temperature
}
