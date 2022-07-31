//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation
import CoreLocation

protocol WeatherManagerServiceDelegate: NSObjectProtocol {
    func willFetchWeather(forLocation city: String)
    func didFetchWeather(_ data: Weather, forLocation city: String)
    func didFail(with error: WeatherManagerError)
}

protocol WeatherManagerService {
    var delegate: WeatherManagerServiceDelegate? { get set }
    
    func fetchWeather(forLocation coordinates: CLLocationCoordinate2D)
    func fetchWeahter(forLocation city: String)
}

final class WeatherManager: WeatherManagerService {
    static let shared: WeatherManagerService = WeatherManager()
    private init() {}
    
    weak var delegate: WeatherManagerServiceDelegate? = nil
    
    private lazy var fetchedCityClosure: (_ result: Result<CityDetail, WeatherManagerError>) -> Void = { [weak self] result in
        switch result {
        case .failure(let error):
            self?.delegate?.didFail(with: error)
        case .success(let cityDetail):
            self?.fetchWeather(forCity: cityDetail)
        }
    }
    
    func fetchWeather(forLocation coordinates: CLLocationCoordinate2D) {
        fetchCityDetails(for: coordinates, completionHandler: fetchedCityClosure)
    }
    
    func fetchWeahter(forLocation city: String) {
        fetchCityDetails(for: city, completionHandler: fetchedCityClosure)
    }
    
    private func fetchWeather(forCity detail: CityDetail) {
        delegate?.willFetchWeather(forLocation: detail.name)
        fetchWeather(forCity: detail, completionHandler: { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.didFail(with: error)
            case .success(let weather):
                self?.delegate?.didFetchWeather(weather, forLocation: detail.name)
            }
        })

    }
}

extension WeatherManager {
    private func fetchWeather(forCity cityDetail: CityDetail, completionHandler: @escaping (_ result: Result<Weather, WeatherManagerError>) -> Void) {
        
    }
    
    private func fetchCityDetails(for coordinates: CLLocationCoordinate2D, completionHandler: @escaping (_ result: Result<CityDetail, WeatherManagerError>) -> Void) {
        
    }
    
    private func fetchCityDetails(for searchText: String, completionHandler: @escaping (_ result: Result<CityDetail, WeatherManagerError>) -> Void) {
        
    }
}
