//
//  ImageView.swift
//  Dodo
//
//  Created by Rishat Zakirov on 04.08.2024.
//

import UIKit
enum ImageViewType {
    case product
    case promo
}
class ImageView: UIImageView {
    init(type: ImageViewType) {
        super.init(frame: .zero)
        commonInit(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(_ type: ImageViewType) {
        switch type {
        case .product:
            makeProductStyle()
        case .promo:
            makePromoStyle()
        }

    }
    
    func makeProductStyle() {
        image = UIImage(named: "pizza")
        contentMode = .scaleAspectFill
        let width = UIScreen.main.bounds.width
        heightAnchor.constraint(equalToConstant: 0.28 * width).isActive = true
        widthAnchor.constraint(equalToConstant: 0.28 * width).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
    }
    
    func makePromoStyle() {
        image = UIImage(named: "pizza")
        contentMode = .scaleAspectFill
        let width = UIScreen.main.bounds.width
        heightAnchor.constraint(equalToConstant: 0.8 * width).isActive = true
        widthAnchor.constraint(equalToConstant: 0.8 * width).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
    }
}
