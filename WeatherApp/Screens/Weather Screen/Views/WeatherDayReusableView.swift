//
//  WeatherDayReusableView.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

final class WeatherDayReusableView: CustomCollectionReusableView {
    let weatherView = WeatherDayView()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherView, separatorView])
        stackView.axis = .vertical
        return stackView
    }()
    
    func setWeather(minTemp: String, maxTemp: String, forDay day: String) {
        weatherView.tempImageView.removeFromSuperview()
        weatherView.dayLabel.text = day
        weatherView.minTemperatureLabel.text = minTemp
        weatherView.maxTemperatureLabel.text = maxTemp
    }
    
    // MARK: - Configuration
    
    override func config() {
        super.config()
        backgroundColor = .darkGray
        weatherView.dayLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension WeatherDayReusableView {
    func setTodaysWeather(_ detail: TodayWeatherDetail) {
        setWeather(minTemp: detail.minTemp, maxTemp: detail.maxTemp, forDay: "Today")
    }
}
