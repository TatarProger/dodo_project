//
//  EmptyCartView.swift
//  Dodo
//
//  Created by Rishat Zakirov on 07.11.2025.
//

import UIKit

class EmptyCartView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let imageView: ImageView = {
        let imageView = ImageView(type: .cart)
        return imageView
    }()

    let emptyLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.text = "Пока тут пусто"
        emptyLabel.textAlignment = .center
        emptyLabel.font = .systemFont(ofSize: 15, weight: .bold)

        return emptyLabel
    }()

    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Добавьте пиццу! Или две."
        descriptionLabel.font = .systemFont(ofSize: 10)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        return descriptionLabel
    }()

    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical

        return stack
    }()

    func setupViews() {
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(emptyLabel)
        stack.addArrangedSubview(descriptionLabel)

        self.addSubview(stack)
        self.backgroundColor = .white
    }

    func setupConstraints() {
        stack.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
}
