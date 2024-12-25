//
//  CategoryCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 06.09.2024.
//

import UIKit
class CategoryCell: UICollectionViewCell {
    static let reuseId = "CategoryCell"
    var onButtonTapped: (()->())?
    let categoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пицца", for: .normal)
        button.titleLabel?.font = UIFont(name: "Dodo Rounded", size: 20)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(nil, action: #selector(tapped), for: .touchUpInside)
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
    
    func update(_ category: Category) {
        categoryButton.setTitle(category.name, for: .normal)
    }
    
    @objc func tapped() {
        onButtonTapped?()
    }
}

extension CategoryCell {
    func setupViews() {
        contentView.addSubview(categoryButton)
    }
    
    func setupConstraints() {
        categoryButton.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
