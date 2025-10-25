//
//  ProductCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 31.07.2024.
//

import UIKit
import SnapKit

final class ProductCell: UITableViewCell {
    static let reusedId = "ProductCell"
    
    
    private var containerView: UIView = {
        $0.backgroundColor = .white
        return $0
        
    }(UIView())

    private var verticalStackView = StackView(15)
    private var nameLabel = Label(text: "Гавайская")
    private var detailLabelView = LabelForDiscription(text: "Тесто, Цыпленок, Моцарелла, Томатный соус")
    private var priceButtonView = Button(text: "от 469 руб")
    private var productImageView = ImageView(type: .product)

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ product: Product) {
        nameLabel.text = product.name
        detailLabelView.text = product.detail
        priceButtonView.setTitle("\(product.price) р", for: .normal)
        print("->",product.image)
        productImageView.image = UIImage(named: product.image)
    }
}


extension ProductCell{
    
    struct Layout {
        static let offset = 16
    }
    private func setupViews() {
        self.selectionStyle = .none
        
        [containerView].forEach{
            contentView.addSubview($0)
        }
        [productImageView, verticalStackView].forEach{
            containerView.addSubview($0)
        }
        [nameLabel, detailLabelView, priceButtonView].forEach{
            verticalStackView.addArrangedSubview($0)
        }
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 20
        containerView.applyShadow(cornerRadius: 20)
    }
    
    private func setupConstraints() {
        productImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.right.equalTo(containerView).offset(0)
            make.left.equalTo(productImageView.snp.right).offset(0)
            make.top.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView).offset(-16)
        }
    }
}



