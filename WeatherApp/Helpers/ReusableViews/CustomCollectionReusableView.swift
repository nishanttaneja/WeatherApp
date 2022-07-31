//
//  CustomCollectionReusableView.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import UIKit

class CustomCollectionReusableView: UICollectionReusableView {
    /// Implement this method for inital setup
    func config() { }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
}
