//
//  TodayWeatherView.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

final class TodayWeatherView: CustomView {
    static private let labelHeight: CGFloat = 14
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        return label
    }()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        return label
    }()
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, imageView, temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    
    // MARK: - Configuration
    
    override func config() {
        super.config()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
