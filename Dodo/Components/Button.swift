//
//  Button.swift
//  Dodo
//
//  Created by Rishat Zakirov on 04.08.2024.
//

import UIKit
class Button: UIButton {
    init(text: String) {
        super.init(frame: .zero)
        commonInit(text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(_ text: String) {
        setTitle(text, for: .normal)
        backgroundColor = .orange.withAlphaComponent(0.1)
        layer.cornerRadius = 20
        setTitleColor(.brown, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
