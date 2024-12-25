//
//  StoriesCell .swift
//  Dodo
//
//  Created by Rishat Zakirov on 31.08.2024.
//

import UIKit
class StoriesCell: UICollectionViewCell {
    
    static let reusedId = "StoriesCell"
    
    let containerView: UIView = {
        let container = UIView()
        container.applyShadow(cornerRadius: 20)
        return container
    }()
    
    let photoImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemBackground
        image.image = UIImage(named: "newPackages")
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 20
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Пицца"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension StoriesCell {
    func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(photoImageView)
        containerView.addSubview(nameLabel)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
        photoImageView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(containerView).inset(20)
        }
    }
}
