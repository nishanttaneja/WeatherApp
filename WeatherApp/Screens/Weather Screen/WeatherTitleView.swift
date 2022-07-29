//
//  WeatherTitleView.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 29/07/22.
//

import UIKit

final class WeatherTitleView: TitleView {
    func setWeather(temperature: String, condition: String, forCity cityName: String) {
        titleLabel.text = cityName
        subtitleLabel.text = temperature + " | " + condition
    }
}
