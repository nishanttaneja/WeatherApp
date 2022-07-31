//
//  WeatherBackgroundView.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 29/07/22.
//

import UIKit

class WeatherBackgroundView: CustomView {
    private let imageView = UIImageView()
    
    func updateImage(for condition: String) {
        imageView.image = condition.getBackgroundImage()
    }
    
    override func config() {
        super.config()
        backgroundColor = .darkGray
        updateImage(for: "sunny")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
