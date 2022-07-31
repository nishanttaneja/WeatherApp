//
//  WeatherViewCoordinator.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

final class WeatherViewCoordinator: NSObject, Coordinator {
    weak var parentCoordinator: Coordinator? = nil
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController? = nil
    
    func configRootViewController() {
        let storageService: LocationInsertStorageService = LocationCoreDataService()
        let viewModel = WeatherViewViewModel(storageService: storageService)
        let viewController = WeatherViewController(viewModel: viewModel)
        viewController.coordinator = self
        viewModel.delegate = viewController
        rootViewController = viewController
    }
    
    func didSelectLocationListButton() {
        (parentCoordinator as? AppCoordinator)?.weatherViewDidSelectLocationListButton()
    }
}
