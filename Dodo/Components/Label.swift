//
//  Label.swift
//  Dodo
//
//  Created by Rishat Zakirov on 04.08.2024.
//

import UIKit
class Label: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        commonInit(text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(_ text: String) {
        self.text = text
        font = UIFont(name: "Dodo Rounded", size: 20)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
