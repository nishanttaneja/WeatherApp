//
//  HourlyForecast.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

struct HourlyForecast: Decodable {
    let DateTime: String
    let WeatherIcon: Int
    let IconPhrase: String
    let Temperature: Temperature
}

extension HourlyForecast {
    var image: UIImage? {
        UIImage(named: "\(WeatherIcon)")
    }
}
