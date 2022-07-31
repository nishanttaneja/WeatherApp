//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

final class LocationListViewController: CustomViewController {
    weak var coordinator: LocationListViewCoordinator? = nil
    
    private var viewModel: LocationListViewModelProtocol? = nil
    
    convenience init(viewModel: LocationListViewModelProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.view.backgroundColor = .green
    }
}
