//
//  PhotoCollectionCell.swift
//  CollectionView-СписокИнгридиентов
//
//  Created by Rishat Zakirov on 07.08.2024.
//

import UIKit
import SnapKit

class IngredientCollectionCell: UICollectionViewCell {
    
    static let reuseId = "IngredientCollectionCell"
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Маринованные огурчики"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "79р"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    func update(_ ingredient: Ingredient) {
        
        photoImageView.image = UIImage(named: ingredient.imageName)
        nameLabel.text = ingredient.nameOfIngredient
        priceLabel.text = ingredient.price
        
        let selectColor = UIColor.lightGray.withAlphaComponent(0.3)
        let unselectColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        contentView.backgroundColor = ingredient.isSelected ? selectColor : unselectColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IngredientCollectionCell {
    func setupViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    func setupConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.left.right.top.equalTo(contentView)
        }

        nameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentView)
            make.top.equalTo(photoImageView.snp.bottom).offset(10)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentView)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            //make.bottom.equalTo(contentView)
        }

    }
}
