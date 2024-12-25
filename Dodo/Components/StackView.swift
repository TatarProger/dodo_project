//
//  StackView.swift
//  Dodo
//
//  Created by Rishat Zakirov on 04.08.2024.
//

import UIKit
class StackView: UIStackView {
    init(_ spacing: Int){
        super.init(frame: .zero)
        
        commonInit(spacing: spacing)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(spacing: Int) {
        axis = .vertical
        self.spacing = CGFloat(spacing)
        alignment = .leading
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 12, trailing: 0)
        isLayoutMarginsRelativeArrangement = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
