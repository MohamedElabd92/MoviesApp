//
//  Extensions.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 19/09/2021.
//

import Foundation
import UIKit

extension UIView {
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    func setCornerRadius(value: CGFloat) {
        layer.cornerRadius = value
    }
}
