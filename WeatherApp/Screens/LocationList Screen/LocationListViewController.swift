//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

final class LocationListViewController: CustomViewController {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let visualEffectView = UIVisualEffectView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .minimal
        bar.placeholder = " Search..."
        return bar
    }()

    weak var coordinator: LocationListViewCoordinator? = nil
    
    private var viewModel: LocationListViewModelProtocol? = nil
    
    override func config() {
        super.config()
        activityIndicatorView.frame = .zero
        configTableView()
        configVisualEffectView()
        view.addSubview(activityIndicatorView)
        searchBar.delegate = self
    }
    
    convenience init(viewModel: LocationListViewModelProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .secondarySystemGroupedBackground
        self.viewModel = viewModel
        title = "Locations"
    }
}


// MARK: - TableView

extension LocationListViewController: UITableViewDataSource, UITableViewDelegate {
    static private let defaultCellReuseId = "LocationListViewController_UITableViewCell"
    static private let headerReuseId = "LocationListViewController_UITableViewHeaderFooterView"
    
    private func configTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.defaultCellReuseId)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: Self.headerReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .secondarySystemGroupedBackground
        tableView.keyboardDismissMode = .interactive
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getNumberOfLocations() ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.defaultCellReuseId, for: indexPath)
        cell.textLabel?.text = viewModel?.getLocation(at: indexPath.row)?.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        searchBar
    }
    
    // MARK: Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectLocation(at: indexPath.row)
        dismiss(animated: true)
    }
}


// MARK: - View Lifecycle

extension LocationListViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicatorView.frame.size = .init(width: 60, height: 60)
        activityIndicatorView.center = view.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.text = nil
        viewModel?.loadLocations()
    }
}


// MARK: - ViewModelDelegate

extension LocationListViewController: LocationListViewModelDelegate {
    func willFetchLocations() {
        setView(isAnimating: true)
    }
    
    func didFetchLocations() {
        tableView.reloadData()
        setView(isAnimating: false)
    }
    
    func didFail(withError error: Error) {
        let alertController = UIAlertController(title: "some error occurred", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(.init(title: "Dismiss", style: .cancel))
        present(alertController, animated: true)
        setView(isAnimating: false)
    }
}


// MARK: - VisualEffectView

extension LocationListViewController {
    private func configVisualEffectView() {
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(visualEffectView)
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor),
            visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


// MARK: - Loading Animation

extension LocationListViewController {
    private func setView(isAnimating: Bool) {
        visualEffectView.isUserInteractionEnabled = isAnimating
        UIView.animate(withDuration: 0.4) {
            isAnimating ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
            self.visualEffectView.effect = isAnimating ? UIBlurEffect(style: .dark) : nil
        }
    }
}


// MARK: - SearchBar

extension LocationListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text, !city.isEmpty else { return }
        viewModel?.didSearch(city)
        dismiss(animated: true)
    }
}
