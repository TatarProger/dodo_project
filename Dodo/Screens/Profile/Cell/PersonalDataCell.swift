//
//  PersonalDataCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 12.12.2024.
//

import UIKit
class PersonalDataCell: UICollectionViewCell {
    static let reuseId = "PersonalDataCell"
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .gray.withAlphaComponent(0.6)
        stack.layer.cornerRadius = 10
        return stack
    }()
    
    private let nameLabel: UILabel = {
        let text = UILabel()
        text.text = "dodocoins"
        text.textColor = .white
        return text
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PersonalDataCell {
    private func setupViews() {
        contentView.backgroundColor = .purple
        contentView.layer.cornerRadius = 18
        contentView.addSubview(stackView)
        stackView.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(10)
            make.left.equalTo(contentView).inset(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(stackView)
            make.left.right.equalTo(stackView).inset(5)
        }
    }
}
