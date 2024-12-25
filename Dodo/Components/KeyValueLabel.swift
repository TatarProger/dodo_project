//
//  KeyValueLabel.swift
//  rick-morty-4lt
//
//  Created by Artur on 25.11.2024.
//

import UIKit

class KeyValueLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    func commonInit() {
        self.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeKeyString(_ string: String) -> AttributedString {
        var attributedString = AttributedString(string + "\n")
        
        attributedString.foregroundColor = .yellow
        attributedString.backgroundColor = .pink
        attributedString.font = .boldSystemFont(ofSize: 15)
        
        return attributedString
    }
    
    func makeValueString(_ string: String) -> AttributedString {
        var attributedString = AttributedString(string)
        
        attributedString.foregroundColor = .pink
        attributedString.backgroundColor = .yellow
        attributedString.font = .systemFont(ofSize: 15)
        attributedString.underlineStyle = .single
        
        return attributedString
    }
    
    func update(key: String, value: String) {
        
        let keyAttributed = NSAttributedString(makeKeyString(key))
        let valueAttributed = NSAttributedString(makeValueString(value))
        
        let result = NSMutableAttributedString()
        result.append(keyAttributed)
        result.append(valueAttributed)
    
        attributedText = result
    }
    
}
