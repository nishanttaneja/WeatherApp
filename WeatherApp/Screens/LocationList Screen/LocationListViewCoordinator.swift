//
//  LocationListViewCoordinator.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

final class LocationListViewCoordinator: NSObject, Coordinator {
    var parentCoordinator: Coordinator? = nil
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController? = nil
    
    func configRootViewController() {
        let viewModel: LocationListViewModelProtocol = LocationListViewModel()
        let viewController = LocationListViewController(viewModel: viewModel)
        viewController.coordinator = self
        rootViewController = viewController
    }
}
