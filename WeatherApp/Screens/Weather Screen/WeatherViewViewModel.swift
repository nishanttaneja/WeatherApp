//
//  WeatherViewViewModel.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation

protocol WeatherViewViewModelDelegate: NSObjectProtocol {
    func willFetchWeather()
    func didUpdateWeather()
    func didFail(with error: APIServiceError)
}

protocol WeatherViewViewModelProtocol {
    var delegate: WeatherViewViewModelDelegate? { get set }
    
    func getTodaysWeather() -> TodayWeatherDetail?
    func getNumberOfItems(atSection index: Int) -> Int
    func getHourlyWeather(at index: Int) -> HourlyWeatherDetail?
    func getWeatherDetail(forDayAt index: Int) -> WeatherDetail?
}

class WeatherViewViewModel: NSObject, WeatherViewViewModelProtocol {
    private var weatherManager = WeatherManager.shared
    
    weak var delegate: WeatherViewViewModelDelegate? = nil
    
    private var weather: Weather? = nil
    
    override init() {
        super.init()
        weatherManager.delegate = self
        
    }
    
    func getTodaysWeather() -> TodayWeatherDetail? {
        guard let feelsLikeTemp = weather?.feelsLikeTemp,
              let condition = weather?.condition,
              let city = weather?.city else { return nil }
        return .init(temp: feelsLikeTemp, condition: condition, city: city, minTemp: "68", maxTemp: "72")
    }
    
    func getNumberOfItems(atSection index: Int) -> Int {
        10
    }
    
    func getHourlyWeather(at index: Int) -> HourlyWeatherDetail? {
        .init(temp: "\(69-index)", time: "\(12+index)", condition: "cloudy")
    }
    
    func getWeatherDetail(forDayAt index: Int) -> WeatherDetail? {
        .init(day: "Day \(index)", condition: "sunny", minTemp: "\(70-index)", maxTemp: "\(84-index)")
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
