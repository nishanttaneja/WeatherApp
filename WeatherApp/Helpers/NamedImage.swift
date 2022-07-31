//
//  NamedImage.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation
import UIKit

enum NamedImage: String {
    case bolt, clouds, drizzle, fog, rain, snow, sun
}

extension UIImage {
    static func getNamedImage(_ value: NamedImage) -> UIImage? {
        UIImage(named: value.rawValue)
    }
}
