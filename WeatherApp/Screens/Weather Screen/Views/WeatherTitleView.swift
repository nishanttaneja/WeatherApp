//
//  WeatherTitleView.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 29/07/22.
//

import UIKit

final class WeatherTitleView: TitleView {
    override class func getPadding() -> UIEdgeInsets {
        UIEdgeInsets(top: .zero, left: .zero, bottom: 16, right: .zero)
    }
    
    func setWeather(temperature: String, condition: String, forCity cityName: String) {
        titleLabel.text = cityName
        subtitleLabel.text = temperature + " | " + condition
    }
    
    override func config() {
        super.config()
    }
}

extension WeatherTitleView {
    func setWeather(_ detail: TodayWeatherDetail) {
        setWeather(temperature: detail.temp, condition: detail.condition, forCity: detail.city)
    }
}
