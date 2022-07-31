//
//  WeatherViewViewModel.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation
import CoreLocation

protocol WeatherViewViewModelDelegate: NSObjectProtocol {
    func willFetchWeather()
    func didUpdateWeather()
    func didFail(with error: APIServiceError)
    func willFetchCurrentLocation()
}

protocol WeatherViewViewModelProtocol {
    var delegate: WeatherViewViewModelDelegate? { get set }
    
    func getTodaysWeather() -> TodayWeatherDetail?
    func getNumberOfItems(atSection index: Int) -> Int
    func getHourlyWeather(at index: Int) -> HourlyWeatherDetail?
    func getWeatherDetail(forDayAt index: Int) -> WeatherDetail?
    
    func fetchWeatherForCurrentLocation()
}

class WeatherViewViewModel: NSObject, WeatherViewViewModelProtocol {
    private let storageService: LocationInsertStorageService
    
    init(storageService: LocationInsertStorageService) {
        self.storageService = storageService
        super.init()
        weatherManager.delegate = self
        locationManager.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectCity(notification:)), name: .selectCity, object: nil)
    }
    
    private var weatherManager = WeatherManager.shared
    private let locationManager = CLLocationManager()
    
    weak var delegate: WeatherViewViewModelDelegate? = nil
    
    private var weather: Weather? = nil
    
    @objc private func didSelectCity(notification: NSNotification) {
        debugPrint(notification.object as? String)
    }
    
    func getTodaysWeather() -> TodayWeatherDetail? {
        guard let feelsLikeTemp = weather?.feelsLikeTemp,
              let condition = weather?.condition,
              let city = weather?.city,
              let minTemp = weather?.minTemp,
              let maxTemp = weather?.maxTemp else { return nil }
        return .init(temp: feelsLikeTemp, condition: condition, city: city, minTemp: minTemp, maxTemp: maxTemp, image: weather?.image)
    }
    
    func getNumberOfItems(atSection index: Int) -> Int {
        switch WeatherViewController.WeatherViewSectionKind(rawValue: index) {
        case .today:
            return weather?.hourlyForecast.count ?? .zero
        case .nextTenDays:
            return weather?.forecasts.count ?? .zero
        default:
            return .zero
        }
    }
    
    func getHourlyWeather(at index: Int) -> HourlyWeatherDetail? {
        guard let forecasts = weather?.hourlyForecast,
              index < forecasts.count else { return nil }
        let forecast = forecasts[index]
        let hour = forecast.DateTime.components(separatedBy: "T").last?.components(separatedBy: ":").first ?? ""
        return .init(temp: "\(Int(forecast.Temperature.Value))", time: hour, condition: forecast.IconPhrase, image: forecast.image)
    }
    
    func getWeatherDetail(forDayAt index: Int) -> WeatherDetail? {
        guard let forecasts = weather?.forecasts,
              forecasts.count > index else { return nil }
        let forecast = forecasts[index]
        let day = forecast.Date.components(separatedBy: "T").first?.components(separatedBy: "-").last ?? ""
        return .init(day: day, condition: forecast.Day.IconPhrase, minTemp: "\(Int(forecast.Temperature.Minimum.Value))", maxTemp: "\(Int(forecast.Temperature.Maximum.Value))", image: forecast.image)
    }
    
    func fetchWeatherForCurrentLocation() {
        guard locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways else {
            locationManager.requestWhenInUseAuthorization()
            fetchWeatherForCurrentLocation()
            return
        }
        delegate?.willFetchCurrentLocation()
        locationManager.startUpdatingLocation()
    }
}


// MARK: - WeatherManagerServiceDelegate

extension WeatherViewViewModel: WeatherManagerServiceDelegate {
    func willFetchWeather(forLocation city: String) {
        DispatchQueue.main.async {
            self.delegate?.willFetchWeather()
        }
    }
    
    func didFetchWeather(_ data: Weather, forLocation city: String) {
        if let cityName = data.city {
            let location = LocationItem(title: cityName)
            storageService.insertLocation(location, completionHandler: { _ in })
        }
        DispatchQueue.main.async {
            self.weather = data
            self.delegate?.didUpdateWeather()
        }
    }
    
    func didFail(with error: APIServiceError) {
        DispatchQueue.main.async {
            self.delegate?.didFail(with: error)
        }
    }
}


// MARK: - CLLocationManagerDelegate

extension WeatherViewViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFail(with: .didFail(with: error))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        locationManager.stopUpdatingLocation()
        weatherManager.fetchWeather(forLocation: coordinate)
    }
}
