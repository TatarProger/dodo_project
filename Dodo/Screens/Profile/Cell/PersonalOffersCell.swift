//
//  PersonalOffersCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 22.12.2024.
//

import UIKit
class PersonalOffersCell: UICollectionViewCell {
    static let reuseId = "PersonalOffersCell"
    
    private let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Применить", for: .normal)
        button.backgroundColor = .orange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
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

extension PersonalOffersCell {
    private func setupViews() {
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 15
        contentView.addSubview(applyButton)
    }
    
    private func setupConstraints() {
        applyButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(10)
            make.left.equalTo(contentView).inset(10)
        }
    }
}
