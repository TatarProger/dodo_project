//
//  MissonsCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 22.12.2024.
//

import UIKit
class MissonsCell: UICollectionViewCell {
    static let reuseId = "MissonsCell"
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Приступим", for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 15
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

extension MissonsCell {
    func setupViews() {
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 15
        contentView.addSubview(startButton)
    }
    
    func setupConstraints() {
        startButton.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView).inset(5)
        }
    }
}
