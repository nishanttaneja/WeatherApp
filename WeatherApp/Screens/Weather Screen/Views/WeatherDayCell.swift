//
//  WeatherDayCell.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

final class WeatherDayCell: CustomCollectionViewCell {
    private let padding = UIEdgeInsets(top: .zero, left: -4, bottom: .zero, right: -4)

    let weatherView = WeatherDayView()
    
    func setWeather(minTemp: String, maxTemp: String, condition: String, forDay day: String) {
        weatherView.tempImageView.image = condition.getSymbolImage()?.withRenderingMode(.alwaysOriginal)
        weatherView.dayLabel.text = day
        weatherView.minTemperatureLabel.text = minTemp
        weatherView.maxTemperatureLabel.text = maxTemp
    }
    
    // MARK: - Configuration
    
    override func config() {
        super.config()
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(weatherView)
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding.top),
            weatherView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: padding.left),
            weatherView.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -padding.right),
            weatherView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom)
        ])
    }
}

extension WeatherDayCell {
    func setWeather(_ detail: WeatherDetail) {
        setWeather(minTemp: detail.minTemp, maxTemp: detail.maxTemp, condition: detail.condition, forDay: detail.day)
    }
}
