//
//  CollectionCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 26.08.2024.
//

import UIKit
class BannerCollectionCell: UICollectionViewCell {
    static let reusedId = "CollectionCell"
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Пеперони"
        label.font = UIFont(name: "Dodo Rounded", size: 15)
        //label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let priceButton: UIButton = {
        let button = UIButton()
        button.setTitle("500р", for: .normal)
        button.backgroundColor = .orange.withAlphaComponent(0.1)
        button.layer.cornerRadius = 20
        button.setTitleColor(.brown, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        return button
    }()
    
    func update(_ product: Product) {
        nameLabel.text = product.name
        priceButton.setTitle("\(product.price) р", for: .normal)
        photoImageView.image = UIImage(named: product.image)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 20
        contentView.applyShadow(cornerRadius: 20)
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceButton)
    }
    func setupConstraints() {
        
        photoImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(photoImageView.snp.right).offset(10)
            make.right.equalTo(contentView).inset(10)
            make.top.equalTo(contentView).offset(20)
        }
        
        priceButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.right.bottom.equalTo(contentView).inset(20)
        }
    }
}


