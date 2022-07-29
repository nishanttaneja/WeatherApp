//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 29/07/22.
//

import UIKit

final class WeatherViewController: CustomViewController {
    private let itemSpacing: CGFloat = 16
    
    private let backgroundView = WeatherBackgroundView()
    private let titleView: WeatherTitleView = {
        let titleView = WeatherTitleView()
        titleView.setWeather(temperature: "29°", condition: "Cloudy", forCity: "New Delhi")
        return titleView
    }()
    private var collectionView: UICollectionView! = nil
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleView])
        stackView.axis = .vertical
        stackView.spacing = itemSpacing
        return stackView
    }()
    
    override func config() {
        super.config()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            // BackgroundView
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // StackView
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        configCollectionView()
    }
}


// MARK: - CollectionView

extension WeatherViewController: UICollectionViewDataSource {
    static private let defaultCellReuseId = "WeatherViewController_defaultCell"
    private func getCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.estimatedItemSize = .init(width: 100, height: 100)
        return flowLayout
    }
    
    private func getCollectionViewLayout() -> UICollectionViewLayout {
        getCollectionViewFlowLayout()
    }
    
    private func configCollectionView() {
        let layout = getCollectionViewLayout()
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .green
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Self.defaultCellReuseId)
        collectionView.dataSource = self
        stackView.addArrangedSubview(collectionView)
    }
    
    // MARK: DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId: String = Self.defaultCellReuseId
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .systemBlue
        return cell
    }
}
