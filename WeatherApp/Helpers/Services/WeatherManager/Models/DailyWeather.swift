//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation
import UIKit

struct DailyWeather: Decodable {
    let DailyForecasts: [DailyForecast]
}

struct DailyForecast: Decodable {
    let Date: String
    let Temperature: TemperatureRange
    let Day: Day
}

extension DailyForecast {
    var image: UIImage? {
        UIImage(named: "\(Day.Icon)")
    }
}

struct Day: Decodable {
    let Icon: Int
    let IconPhrase: String
}

struct TemperatureRange: Decodable {
    let Minimum: Temperature
    let Maximum: Temperature
}

struct Temperature: Decodable {
    let Value: Double
}
