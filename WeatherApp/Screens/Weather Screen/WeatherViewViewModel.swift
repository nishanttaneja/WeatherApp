//
//  WeatherViewViewModel.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation

protocol WeatherViewViewModelProtocol {
    func getTodaysWeather() -> TodayWeatherDetail
    func getNumberOfItems(atSection index: Int) -> Int
    func getHourlyWeather(at index: Int) -> HourlyWeatherDetail?
    func getWeatherDetail(forDayAt index: Int) -> WeatherDetail?
}

struct WeatherViewViewModel: WeatherViewViewModelProtocol {
    func getTodaysWeather() -> TodayWeatherDetail {
        .init(temp: "68°", condition: "Partly Cloudy", city: "New York", minTemp: "68", maxTemp: "72")
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
