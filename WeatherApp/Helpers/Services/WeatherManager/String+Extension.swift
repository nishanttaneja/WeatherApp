//
//  String+Extension.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

extension String {
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
