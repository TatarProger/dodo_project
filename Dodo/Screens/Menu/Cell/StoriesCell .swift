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
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()


//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Пицца"
//        return label
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(imageName: String) {
        photoImageView.image = UIImage(named: imageName)
    }
}


extension StoriesCell {
    func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(photoImageView)
        //containerView.addSubview(nameLabel)
    }

    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(6)
        }
        photoImageView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
//        nameLabel.snp.makeConstraints { make in
//            make.bottom.equalTo(containerView).inset(20)
//        }
    }
}
