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
    
    
    
    var verticalStackView = StackView(15)
    
    var nameLabel = Label(text: "Гавайская")
    
    var detailLabelView = LabelForDiscription(text: "Тесто, Цыпленок, Моцарелла, Томатный соус")
    
    var priceButtonView = Button(text: "от 469 руб")
    
    var productImageView = ImageView(type: .promo)
    
    
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
    func setupViews() {
        verticalStackView.alignment = .center
        self.selectionStyle = .none
        contentView.addSubview(verticalStackView)
        [productImageView, nameLabel, detailLabelView, priceButtonView].forEach{
            verticalStackView.addArrangedSubview($0)
        }
    }
    
    func setupConstraints() {
//        productImageView.snp.makeConstraints { make in
//            make.centerY.equalTo(contentView)
//            make.left.equalTo(contentView).offset(20)
//        }
        
        //containerView.snp.makeConstraints { make in
        //}
        
        verticalStackView.snp.makeConstraints { make in
            //make.left.equalTo(contentView).offset(0)
            make.left.right.equalTo(contentView)
            make.top.bottom.equalTo(contentView).inset(16)
        }
    }
}




