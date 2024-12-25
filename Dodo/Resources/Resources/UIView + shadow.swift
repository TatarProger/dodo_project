//
//  UIView + shadow.swift
//  Dodo
//
//  Created by Rishat Zakirov on 27.11.2024.
//

import UIKit
extension UIView {
    func applyShadow(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
