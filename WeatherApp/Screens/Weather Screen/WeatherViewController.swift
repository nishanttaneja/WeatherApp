//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 29/07/22.
//

import UIKit

final class WeatherViewController: CustomViewController {
    private let padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    
    private let titleView: WeatherTitleView = {
        let titleView = WeatherTitleView()
        titleView.setWeather(temperature: "29°", condition: "Cloudy", forCity: "New Delhi")
        return titleView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleView])
        stackView.axis = .vertical
        stackView.spacing = padding.top
        return stackView
    }()
    
    override func config() {
        super.config()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding.top),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: padding.left),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -padding.right),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom)
        ])
    }
}

