//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 29/07/22.
//

import UIKit

final class WeatherViewController: CustomViewController {
    private let itemSpacing: CGFloat = .zero
    
    private let backgroundView = WeatherBackgroundView()
    private let titleView = WeatherTitleView()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    private var collectionView: UICollectionView! = nil
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleView, separatorView])
        stackView.axis = .vertical
        stackView.spacing = itemSpacing
        return stackView
    }()
    
    private var viewModel: WeatherViewViewModelProtocol? = nil
    
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
    convenience init(viewModel: WeatherViewViewModelProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // Cell Reuse IDs
    static private let defaultCellReuseId = "WeatherViewController_CollectionViewCell_Default"
    static private let todayWeatherCellReuseId = "WeatherViewController_TodayWeatherViewCell_CustomCollectionViewCell"
    static private let weatherDayCellReuseId = "WeatherViewController_WeatherDayCell_CustomCollectionViewCell"
    // SupplementaryView Reuse IDs
    static private let defaultSupplementaryViewReuseId = "WeatherViewController_SupplementaryView_Default"
    static private let weatherDayReusableViewReuseId = "WeatherViewController_WeatherDayReusableView_CustomCollectionReusableView"
    
    enum WeatherViewSectionKind: Int, CaseIterable {
        case today, nextTenDays
    }
    
    private func getCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.estimatedItemSize = .init(width: 100, height: 100)
        return flowLayout
    }
    
    private func getGroupSize(forSection kind: WeatherViewSectionKind?) -> NSCollectionLayoutSize {
        switch kind {
        case .today:
            return .init(widthDimension: .absolute(56), heightDimension: .absolute(144))
        case .nextTenDays:
            return .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        default:
            return .init(widthDimension: .estimated(100), heightDimension: .estimated(100))
        }
    }
    
    private func getCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let supplementaryItemHeight: CGFloat = 44
        let layout = UICollectionViewCompositionalLayout { sectionNumber, _ in
            let sectionKind = WeatherViewSectionKind(rawValue: sectionNumber)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: .zero, leading: 4, bottom: .zero, trailing: 4)
            let groupSize: NSCollectionLayoutSize = self.getGroupSize(forSection: sectionKind)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = .init(top: sectionKind == .today ? supplementaryItemHeight+4 : 4, leading: 4, bottom: 4, trailing: 4)
            let section = NSCollectionLayoutSection(group: group)
            let supItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(sectionKind == .today ? 44 : 1))
            let anchor = NSCollectionLayoutAnchor(edges: .top)
            let supItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: supItemSize, elementKind: UICollectionView.elementKindSectionHeader, containerAnchor: anchor)
            section.boundarySupplementaryItems = [supItem]
            if sectionKind == .today {
                section.orthogonalScrollingBehavior = .continuous
            }
//            supItem.pinToVisibleBounds = true
            return section
        }
        return layout
    }
    
    private func getCollectionViewLayout() -> UICollectionViewLayout {
        //        getCollectionViewFlowLayout()
        getCollectionViewCompositionalLayout()
    }
    
    private func configCollectionView() {
        let layout = getCollectionViewLayout()
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Self.defaultCellReuseId)
        collectionView.register(TodayWeatherCell.self, forCellWithReuseIdentifier: Self.todayWeatherCellReuseId)
        collectionView.register(WeatherDayCell.self, forCellWithReuseIdentifier: Self.weatherDayCellReuseId)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Self.defaultSupplementaryViewReuseId)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Self.defaultSupplementaryViewReuseId)
        collectionView.register(WeatherDayReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Self.weatherDayReusableViewReuseId)
        collectionView.dataSource = self
        stackView.addArrangedSubview(collectionView)
    }
    
    // MARK: DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        WeatherViewSectionKind.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.getNumberOfItems(atSection: section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId: String = Self.defaultCellReuseId
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        guard let sectionKind = WeatherViewSectionKind(rawValue: indexPath.section) else { return cell }
        switch sectionKind {
        case .today:
            guard let todayWeatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.todayWeatherCellReuseId, for: indexPath) as? TodayWeatherCell,
                  let hourlyWeather = viewModel?.getHourlyWeather(at: indexPath.item) else { return cell }
            todayWeatherCell.setTemperature(hourlyWeather)
            return todayWeatherCell
        case .nextTenDays:
            guard let weatherDayCell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.weatherDayCellReuseId, for: indexPath) as? WeatherDayCell,
                  let weatherDetail = viewModel?.getWeatherDetail(forDayAt: indexPath.item) else { return cell }
            weatherDayCell.setWeather(weatherDetail)
            return weatherDayCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Self.defaultSupplementaryViewReuseId, for: indexPath)
        guard kind == UICollectionView.elementKindSectionHeader, let sectionKind = WeatherViewSectionKind(rawValue: indexPath.section) else { return supView }
        switch sectionKind {
        case .today:
            guard let weatherDayView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Self.weatherDayReusableViewReuseId, for: indexPath) as? WeatherDayReusableView, let todaysWeather = viewModel?.getTodaysWeather() else {
                supView.backgroundColor = .lightGray
                return supView
            }
            weatherDayView.setTodaysWeather(todaysWeather)
            return weatherDayView
        case .nextTenDays:
            supView.backgroundColor = .lightGray
            return supView
        }
    }
}


// MARK: - View Lifecycle

extension WeatherViewController {    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let todaysWeather = viewModel?.getTodaysWeather() {
            titleView.setWeather(todaysWeather)
        }
    }
}


// MARK: - WeatherViewViewModelDelegate

extension WeatherViewController: WeatherViewViewModelDelegate {
    func willFetchWeather() {
        // Start Loading animation
        debugPrint(#function)
    }
    
    func didFail(with error: APIServiceError) {
        // Display Error Message
        debugPrint(#function)
    }
    
    func didUpdateWeather() {
        debugPrint(#function)
        if let todaysWeather = viewModel?.getTodaysWeather() {
            titleView.setWeather(todaysWeather)
        }
        collectionView.reloadData()
    }
}
