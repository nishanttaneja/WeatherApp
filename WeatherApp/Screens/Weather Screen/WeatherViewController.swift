//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 29/07/22.
//

import UIKit

final class WeatherViewController: CustomViewController {
    private let itemSpacing: CGFloat = .zero
    private let toolBarHeight: CGFloat = 44
    
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
    private let visualEffectView = UIVisualEffectView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private lazy var bottomToolBar: UIToolbar = {
        let bar = UIToolbar(frame: .init(origin: .zero, size: .init(width: view.frame.width, height: toolBarHeight)))
        let currentLocationItem = UIBarButtonItem(image: UIImage(systemName: "location"), style: .plain, target: self, action: #selector(handleAction(ofCurrentLocation:)))
        let locationListItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(handleAction(ofLocationList:)))
        bar.setItems([currentLocationItem, UIBarButtonItem.flexibleSpace(), locationListItem], animated: true)
        return bar
    }()
    
    weak var coordinator: WeatherViewCoordinator? = nil
    
    private var viewModel: WeatherViewViewModelProtocol? = nil
    
    @objc private func handleAction(ofCurrentLocation button: UIBarButtonItem) {
        viewModel?.fetchWeatherForCurrentLocation()
    }
    
    @objc private func handleAction(ofLocationList button: UIBarButtonItem) {
        coordinator?.didSelectLocationListButton()
    }
    
    override func config() {
        super.config()
        activityIndicatorView.frame = .zero
        visualEffectView.isUserInteractionEnabled = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        view.addSubview(stackView)
        view.addSubview(bottomToolBar)
        view.addSubview(visualEffectView)
        view.addSubview(activityIndicatorView)
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
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            // VisualEffectView
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor),
            visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        guard kind == UICollectionView.elementKindSectionHeader,
              WeatherViewSectionKind(rawValue: indexPath.section) == .today,
              let weatherDayView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Self.weatherDayReusableViewReuseId, for: indexPath) as? WeatherDayReusableView,
              let todaysWeather = viewModel?.getTodaysWeather() else {
            return supView
        }
        weatherDayView.setTodaysWeather(todaysWeather)
        return weatherDayView
    }
}


// MARK: - View Lifecycle

extension WeatherViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicatorView.frame.size = .init(width: 60, height: 60)
        activityIndicatorView.center = view.center
        let toolBarHeight = self.toolBarHeight + view.safeAreaInsets.bottom
        let barSize = CGSize(width: view.frame.width, height: toolBarHeight)
        bottomToolBar.frame.origin = .init(x: .zero, y: view.frame.height-toolBarHeight)
        bottomToolBar.frame.size = bottomToolBar.sizeThatFits(barSize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setView(isAnimating: true)
        viewModel?.fetchWeatherForCurrentLocation()
        if let todaysWeather = viewModel?.getTodaysWeather() {
            titleView.setWeather(todaysWeather)
        }
    }
}


// MARK: - WeatherViewViewModelDelegate

extension WeatherViewController: WeatherViewViewModelDelegate {
    func willFetchWeather() {
        setView(isAnimating: true)
    }
    
    func willFetchCurrentLocation() {
        setView(isAnimating: true)
    }
    
    func didFail(with error: APIServiceError) {
        let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alertController.addAction(.init(title: "Dismiss", style: .cancel))
        present(alertController, animated: true)
        setView(isAnimating: false)
    }
    
    func didUpdateWeather() {
        if let todaysWeather = viewModel?.getTodaysWeather() {
            titleView.setWeather(todaysWeather)
            backgroundView.updateImage(for: todaysWeather.condition)
        }
        collectionView.reloadData()
        setView(isAnimating: false)
    }
}


// MARK: - Loading Animation

extension WeatherViewController {
    private func setView(isAnimating: Bool) {
        visualEffectView.isUserInteractionEnabled = isAnimating
        UIView.animate(withDuration: 0.4) {
            isAnimating ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
            self.visualEffectView.effect = isAnimating ? UIBlurEffect(style: .dark) : nil
        }
    }
}
