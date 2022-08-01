//
//  LocationListViewModel.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation

protocol LocationListViewModelDelegate: NSObjectProtocol {
    func willFetchLocations()
    func didFetchLocations()
    func didFail(withError error: Error)
}

protocol LocationListViewModelProtocol {
    var delegate: LocationListViewModelDelegate? { get set }
    func getNumberOfLocations() -> Int
    func getLocation(at index: Int) -> LocationItem?
    func didSelectLocation(at index: Int)
    func loadLocations()
    func didSearch(_ text: String)
}

final class LocationListViewModel: NSObject, LocationListViewModelProtocol {
    private var locations: [LocationItem] = []
    private let storageService: LocationFetchStorageService
    
    weak var delegate: LocationListViewModelDelegate? = nil {
        didSet {
           loadLocations()
        }
    }
    
    init(storageService: LocationFetchStorageService) {
        self.storageService = storageService
        super.init()
    }
    
    func getNumberOfLocations() -> Int {
        locations.count
    }
    
    func getLocation(at index: Int) -> LocationItem? {
        guard locations.count > index else { return nil }
        return locations[index]
    }
    
    func didSelectLocation(at index: Int) {
        guard locations.count > index else { return }
        let location = locations[index]
        postNotification(forLocation: location.title)
    }
    
    func didSearch(_ text: String) {
        postNotification(forLocation: text)
    }
    
    func loadLocations() {
        delegate?.willFetchLocations()
        storageService.fetchAllLocations { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let locations):
                    self?.locations = locations
                    self?.delegate?.didFetchLocations()
                case .failure(let error):
                    self?.delegate?.didFail(withError: error)
                }
            }
        }
    }
}

extension LocationListViewModel {
    private func postNotification(forLocation title: String) {
        NotificationCenter.default.post(name: .selectCity, object: title)
    }
}
