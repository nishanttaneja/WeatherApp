//
//  TodayWeatherView.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

final class TodayWeatherView: CustomView {
    static private let labelHeight: CGFloat = 14
    static private let padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
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
        let padding: UIEdgeInsets = Self.padding
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom)
        ])
    }
}
