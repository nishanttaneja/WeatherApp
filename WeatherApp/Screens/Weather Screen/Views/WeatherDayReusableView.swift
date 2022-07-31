//
//  WeatherDayReusableView.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

final class WeatherDayReusableView: CustomCollectionReusableView {
    private let padding = UIEdgeInsets(top: 4, left: 24, bottom: 4, right: 24)

    let weatherView = WeatherDayView()
    
    func setWeather(minTemp: String, maxTemp: String, forDay day: String) {
        weatherView.tempImageView.image = .init(systemName: "cloud.sun")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        weatherView.dayLabel.text = day
        weatherView.minTemperatureLabel.text = minTemp
        weatherView.maxTemperatureLabel.text = maxTemp
    }
    
    // MARK: - Configuration
    
    override func config() {
        super.config()
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(weatherView)
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding.top),
            weatherView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: padding.left),
            weatherView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -padding.right),
            weatherView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom)
        ])
    }
}
