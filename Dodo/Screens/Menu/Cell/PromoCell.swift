//
//  PromoCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 27.11.2024.
//


import UIKit
import SnapKit

class PromoCell: UITableViewCell {
    static let reusedId = "ProductCell"
    private var verticalStackView = StackView(15)

    private var nameLabel = Label(text: "Гавайская")

    private var detailLabelView = LabelForDiscription(text: "Тесто, Цыпленок, Моцарелла, Томатный соус")

    private var priceButtonView = Button(text: "от 469 руб")

    private var productImageView = ImageView(type: .promo)
    
    
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


extension PromoCell{
    
    struct Layout {
        static let offset = 16
    }
    private func setupViews() {
        verticalStackView.alignment = .center
        self.selectionStyle = .none
        contentView.addSubview(verticalStackView)
        [productImageView, nameLabel, detailLabelView, priceButtonView].forEach{
            verticalStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        verticalStackView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView)
            make.top.bottom.equalTo(contentView).inset(16)
        }
    }
}




