//
//  TitleView.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 29/07/22.
//

import UIKit

class TitleView: CustomView {
    class func getPadding() -> UIEdgeInsets {
        UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
    }
    
//    let fixedHeight: CGFloat = 60
    let itemSpacing: CGFloat = 2
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        return label
    }()
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "-- | --"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private(set) lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = itemSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    override func config() {
        super.config()
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleStackView)
        let padding: UIEdgeInsets = Self.getPadding()
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding.top),
            titleStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: padding.left),
            titleStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -padding.right),
            titleStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom)
        ])
    }
}
