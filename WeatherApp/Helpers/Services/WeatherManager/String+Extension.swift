//
//  String+Extension.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

extension String {
    func getSymbolImage() -> UIImage? {
        switch self.lowercased() {
        case "cloudy":
            return .init(systemName: "cloud.fill")?.withTintColor(.white)
        case "mostly cloudy":
            return .init(systemName: "cloud.fill")?.withTintColor(.darkGray)
        case "thunderstorms":
            return .init(systemName: "cloud.bolt.fill")
        case "rain":
            return .init(systemName: "cloud.rain.fill")
        default:
            return .init(systemName: "cloud.sun.fill")
        }
    }
    
    func getBackgroundImage() -> UIImage? {
        switch self.lowercased() {
        case "cloudy":
            return .getNamedImage(.clouds)
        case "mostly cloudy":
            return .getNamedImage(.clouds)
        case "thunderstorms":
            return .getNamedImage(.bolt)
        case "rain":
            return .getNamedImage(.rain)
        default:
            return .getNamedImage(.sun)
        }
    }
}
