//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

protocol Coordinator: NSObjectProtocol {
    var parentCoordinator: Coordinator? { get }
    var childCoordinators: [Coordinator] { get }
    var rootViewController: UIViewController? { get }
    func configRootViewController()
}

final class AppCoordinator: NSObject, Coordinator {
    private(set) weak var parentCoordinator: Coordinator? = nil
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var rootViewController: UIViewController? = nil
    
    private let locationListCoordinator = LocationListViewCoordinator()
    private let weatherViewCoordinator = WeatherViewCoordinator()
    
    func configRootViewController() {
        locationListCoordinator.parentCoordinator = self
        locationListCoordinator.configRootViewController()
        weatherViewCoordinator.parentCoordinator = self
        weatherViewCoordinator.configRootViewController()
        childCoordinators = [weatherViewCoordinator, locationListCoordinator]
        rootViewController = weatherViewCoordinator.rootViewController
    }
    
    func weatherViewDidSelectLocationListButton() {
        guard let locationListView = locationListCoordinator.rootViewController else { return }
        rootViewController?.present(locationListView, animated: true)
    }
}
