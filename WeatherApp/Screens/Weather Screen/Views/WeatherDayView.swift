//
//  WeatherDayView.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

final class WeatherDayView: CustomView {
    private let padding = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    private let itemSpacing: CGFloat = 20
    
    
    // MARK: - Subviews
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    let tempImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        return imageView
    }()
    let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .lightGray
        return label
    }()
    let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    private lazy var temperatureStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [maxTemperatureLabel, minTemperatureLabel])
        stackView.distribution = .fillEqually
        stackView.spacing = itemSpacing
        return stackView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dayLabel, tempImageView, temperatureStackView])
        stackView.distribution = .equalCentering
        stackView.spacing = itemSpacing
        return stackView
    }()
    
    
    // MARK: - Configuration
    
    override func config() {
        super.config()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom)
        ])
    }
}
