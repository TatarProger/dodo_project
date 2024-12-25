//
//  GalleryCollectionViewCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 11.08.2024.
//

import UIKit

class AdditionsCollectionCell: UICollectionViewCell {
    
    static let reuseId = "AdditionsCollectionViewCell "
    
    let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.applyShadow(cornerRadius: 20)
        return container
    }()
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.font = UIFont(name: "Dodo Rounded", size: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    let priceButton: UIButton = {
        
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .lightGray.withAlphaComponent(0.5)
        configuration.baseForegroundColor = .black
        
        let button = UIButton.init(configuration: configuration, primaryAction: nil)
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
    
    func update(_ product: Product) {
        nameLabel.text = product.name
        priceButton.setTitle("\(product.price) р", for: .normal)
        mainImageView.image = UIImage(named: product.image)
    }
}


//MARK: LAYOUT
extension AdditionsCollectionCell {
    
    
    
    func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(mainImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceButton)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(10)
            make.top.equalTo(contentView).offset(60)
            make.bottom.equalTo(contentView).inset(10)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.centerX.equalTo(contentView)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
            make.left.right.equalTo(containerView).inset(10)
        }

        priceButton.snp.makeConstraints { make in
            make.left.right.equalTo(containerView).inset(10)
            make.bottom.equalTo(containerView).inset(10)

        }
        

    }
    
}
