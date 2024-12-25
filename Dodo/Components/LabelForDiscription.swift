//
//  LabelForDiscription.swift
//  Dodo
//
//  Created by Rishat Zakirov on 04.08.2024.
//

import UIKit

class LabelForDiscription:UILabel {
    init(text: String) {
        super.init(frame: .zero)
        commonInit(text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(_ text: String) {
        self.text = text
        textColor = .darkGray
        numberOfLines = 0
        font = UIFont.boldSystemFont(ofSize: 15)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
