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
        let storageService: LocationFetchStorageService = LocationCoreDataService()
        var viewModel: LocationListViewModelProtocol = LocationListViewModel(storageService: storageService)
        let viewController = LocationListViewController(viewModel: viewModel)
        viewModel.delegate = viewController as LocationListViewModelDelegate
        viewController.coordinator = self
        rootViewController = UINavigationController(rootViewController: viewController)
    }
}
