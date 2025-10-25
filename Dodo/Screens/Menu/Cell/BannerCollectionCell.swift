//
//  CollectionCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 26.08.2024.
//

import UIKit
import Kingfisher
import Nuke
final class BannerCollectionCell: UICollectionViewCell {
    static let reusedId = "CollectionCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Пеперони"
        label.font = UIFont(name: "Dodo Rounded", size: 15)
        return label
    }()
    
    private let priceButton: UIButton = {
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
        guard let url = URL(string: "https://i.postimg.cc/26GJBJNk/temp-Imagef7-TRHK.avif") else {return}
        
        Task {
            let imageTask = ImagePipeline.shared.imageTask(with: url)
            photoImageView.image = try await imageTask.image
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 20
        contentView.applyShadow(cornerRadius: 20)
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceButton)
    }
    private func setupConstraints() {
        
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


