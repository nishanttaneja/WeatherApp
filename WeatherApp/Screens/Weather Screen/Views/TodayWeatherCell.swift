//
//  TodayWeatherCell.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

final class TodayWeatherCell: CustomCollectionViewCell {
    private let padding = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
    
    private let weatherView = TodayWeatherView()
    
    func setTemperature(_ temp: String, forTime time: String) {
        weatherView.temperatureLabel.text = temp
        weatherView.timeLabel.text = time
        weatherView.imageView.image = .init(systemName: "cloud.sun")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    }
    
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
