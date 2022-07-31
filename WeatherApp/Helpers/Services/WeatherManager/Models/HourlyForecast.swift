//
//  HourlyForecast.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation

struct HourlyForecast: Decodable {
    let DateTime: String
    let IconPhrase: String
    let RealFeelTemperature: Temperature
}
