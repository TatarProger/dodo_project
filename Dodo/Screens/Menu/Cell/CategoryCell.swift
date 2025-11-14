//
//  CategoryCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 06.09.2024.
//

import UIKit
final class CategoryCell: UICollectionViewCell {
    static let reuseId = "CategoryCell"
    var onButtonTapped: (()->())?
    private let categoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пицца", for: .normal)
        button.titleLabel?.font = UIFont(name: "Dodo Rounded", size: 20)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(nil, action: #selector(tapped), for: .touchUpInside)
        return button
    }()

    let containerView: UIView = {
        let container = UIView()
        container.applyShadow(cornerRadius: 20)
        container.backgroundColor = .white
        return container
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
    private func setupViews() {
        containerView.addSubview(categoryButton)
        contentView.addSubview(containerView)
    }
    
    private func setupConstraints() {

        categoryButton.snp.makeConstraints { make in
            make.edges.equalTo(containerView).inset(4)
            make.left.equalTo(containerView).inset(8)
            make.right.equalTo(containerView).inset(8)
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(2)
        }
    }
}
