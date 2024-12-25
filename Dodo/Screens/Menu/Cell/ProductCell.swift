//
//  ProductCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 31.07.2024.
//

import UIKit
import SnapKit

class ProductCell: UITableViewCell {
    static let reusedId = "ProductCell"
    
    
    private var containerView: UIView = {
//        var view =  UIView()
//        view.backgroundColor = .white
//        view.applyShadow(cornerRadius: 10)
//        return view
        $0.backgroundColor = .white
        return $0
        
    }(UIView())
    
    
//    var verticalStackView: UIStackView = {
//        var stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 15
//        stackView.alignment = .leading
//        
//        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 12, trailing: 0)
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
    var verticalStackView = StackView(15)
    
//    var nameLabel: UILabel = {
//        let nameLabel = UILabel()
//        nameLabel.text = "Гавайская"
//        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        return nameLabel
//    }()
    var nameLabel = Label(text: "Гавайская")
    
//    var detailLabelView: UILabel = {
//        let detailLabel = UILabel()
//        detailLabel.text = "Тесто, Цыпленок, Моцарелла, Томатный соус"
//        detailLabel.textColor = .darkGray
//        detailLabel.numberOfLines = 0
//        detailLabel.font = UIFont.boldSystemFont(ofSize: 15)
//        detailLabel.translatesAutoresizingMaskIntoConstraints = false
//        return detailLabel
//    }()
    var detailLabelView = LabelForDiscription(text: "Тесто, Цыпленок, Моцарелла, Томатный соус")
    
//    var priceButtonView: UIButton = {
//        let button = UIButton()
//        button.setTitle("от 469 руб", for: .normal)
//        button.backgroundColor = .orange.withAlphaComponent(0.1)
//        button.layer.cornerRadius = 20
//        button.setTitleColor(.brown, for: .normal)
//        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    var priceButtonView = Button(text: "от 469 руб")
    
//    var productImageView: UIImageView = {
//        var imageView = UIImageView()
//        imageView.image = UIImage(named: "pizza")
//        imageView.contentMode = .scaleAspectFill
//        let width = UIScreen.main.bounds.width
//        imageView.heightAnchor.constraint(equalToConstant: 0.40 * width).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 0.40 * width).isActive = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    var productImageView = ImageView(type: .product)
    
    
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
    func setupViews() {
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
    
    func setupConstraints() {
        productImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.right.equalTo(containerView).offset(0)
            //make.left.equalTo(contentView).offset(0)
            make.left.equalTo(productImageView.snp.right).offset(0)
            make.top.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView).offset(-16)
        }
    }
}



