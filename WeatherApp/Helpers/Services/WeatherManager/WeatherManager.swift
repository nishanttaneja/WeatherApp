//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation
import CoreLocation

struct WeatherManagerConstant {
    static let kApiKey = "apikey"
    static let kDetails = "details"
    static let kMetric = "metric"
}

protocol WeatherManagerServiceDelegate: NSObjectProtocol {
    func willFetchWeather(forLocation city: String)
    func didFetchWeather(_ data: Weather, forLocation city: String)
    func didFail(with error: APIServiceError)
}

protocol WeatherManagerService {
    var delegate: WeatherManagerServiceDelegate? { get set }
    
    func fetchWeather(forLocation coordinates: CLLocationCoordinate2D)
    func fetchWeahter(forLocation city: String)
}

final class WeatherManager: WeatherManagerService {
    static let shared: WeatherManagerService = WeatherManager()
    private init() {
        fetchWeather(forCity: .init(Key: "187745", LocalizedName: "New Delhi"))
    }
    
    private let apiKey = "L2qDHC76QoM6GbLe8S6qXdioYWVpNSbP"
    private let currentConditionsAPIService: APIService = .currentConditions
    private let hourlyForecastAPIService: APIService = .hourlyForecast
    private let fiveDayForecastAPIService: APIService = .fiveDayForecast
    
    weak var delegate: WeatherManagerServiceDelegate? = nil
    
    private lazy var fetchedCityClosure: (_ result: Result<CityDetail, APIServiceError>) -> Void = { [weak self] result in
        switch result {
        case .failure(let error):
            self?.delegate?.didFail(with: error)
        case .success(let cityDetail):
            self?.fetchWeather(forCity: cityDetail)
        }
    }
    private var weather: Weather = .init()
    
    private let dispatchGroup = DispatchGroup()
    
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

struct Weather {
    var condition: String?
    var feelsLikeTemp: String?
    var city: String?
    var hourlyForecast: [HourlyForecast] = []
    var minTemp: String?
    var maxTemp: String?
    var forecasts: [DailyForecasts] = []
}

extension WeatherManager {
    private func fetchWeather(forCity cityDetail: CityDetail, completionHandler: @escaping (_ result: Result<Weather, APIServiceError>) -> Void) {
        weather.city = cityDetail.LocalizedName
        let params: [URLQueryItem] = [
            .init(name: WeatherManagerConstant.kApiKey, value: apiKey),
            .init(name: WeatherManagerConstant.kDetails, value: "true"),
        ]
        let cityKey = "/\(cityDetail.Key)"
        fetchCurrentWeatherConditions(appendingString: cityKey, withParameters: params)
        fetchHourlyForecast(appendingString: cityKey, withParamters: params)
        fetch5DaysForecast(appendingString: cityKey, withParameters: params)
        dispatchGroup.notify(queue: .main) {
            completionHandler(.success(self.weather))
        }
    }
    
    private func fetchCurrentWeatherConditions(appendingString: String, withParameters params: [URLQueryItem]) {
        dispatchGroup.enter()
        currentConditionsAPIService.fetchResponse(appendingString: appendingString, withParameters: params) { result in
            switch result {
            case .success(let currentWeather):
                guard let currentCondition = currentWeather.first else { break }
                self.weather.feelsLikeTemp = "\(currentCondition.Temperature.Metric.Value)°"
                self.weather.condition = currentCondition.WeatherText
                self.weather.minTemp = "\(Int(currentCondition.TemperatureSummary.Past6HourRange.Minimum.Metric.Value))"
                self.weather.maxTemp = "\(Int(currentCondition.TemperatureSummary.Past6HourRange.Maximum.Metric.Value))"
            case .failure(let error):
                self.delegate?.didFail(with: error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func fetchHourlyForecast(appendingString text: String, withParamters params: [URLQueryItem]) {
        dispatchGroup.enter()
        var params = params
        params.append(.init(name: WeatherManagerConstant.kMetric, value: "true"))
        hourlyForecastAPIService.fetchResponse(appendingString: text, withParameters: params) { result in
            switch result {
            case .failure(let error):
                self.delegate?.didFail(with: error)
            case .success(let hourlyForecast):
                self.weather.hourlyForecast = hourlyForecast
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func fetch5DaysForecast(appendingString text: String, withParameters params: [URLQueryItem]) {
        dispatchGroup.enter()
        var params = params
        params.append(.init(name: WeatherManagerConstant.kMetric, value: "true"))
        fiveDayForecastAPIService.fetchResponse(appendingString: text, withParameters: params) { result in
            switch result {
            case .failure(let error):
                self.delegate?.didFail(with: error)
            case .success(let dailyWeather):
                self.weather.forecasts = dailyWeather.DailyForecasts
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func fetchCityDetails(for coordinates: CLLocationCoordinate2D, completionHandler: @escaping (_ result: Result<CityDetail, APIServiceError>) -> Void) {
        
    }
    
    private func fetchCityDetails(for searchText: String, completionHandler: @escaping (_ result: Result<CityDetail, APIServiceError>) -> Void) {
        
    }
}
