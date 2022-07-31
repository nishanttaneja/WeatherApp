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
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 72)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    func setWeather(temperature: String, condition: String, forCity cityName: String) {
        titleLabel.text = cityName
        subtitleLabel.text = condition
        tempLabel.text = temperature
    }
    
    override func config() {
        super.config()
        stackView.spacing = 4
        stackView.addArrangedSubview(tempLabel)
    }
}

extension WeatherTitleView {
    func setWeather(_ detail: TodayWeatherDetail) {
        setWeather(temperature: detail.temp, condition: detail.condition, forCity: detail.city)
    }
}
