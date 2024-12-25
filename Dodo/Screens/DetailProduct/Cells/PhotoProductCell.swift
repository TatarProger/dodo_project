//
//  PhotoProductCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 04.09.2024.
//

import UIKit


class PhotoProductCell: UITableViewCell {

    //static let reuseId = "PhotoProductCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    
    let photoImageView: UIImageView = {
        let photo = UIImageView()
        photo.image = UIImage(named: "margarita")
        photo.contentMode = .scaleAspectFit
        photo.heightAnchor.constraint(equalToConstant: ScreenSize.width * 0.8).isActive = true
        photo.widthAnchor.constraint(equalToConstant: ScreenSize.width * 0.8).isActive = true
        
        
        return photo
        
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ product: Product?) {
        photoImageView.image = UIImage(named: product?.image ?? "")
    }
}


extension PhotoProductCell {
    func setupViews() {
        selectionStyle = .none
        contentView.addSubview(photoImageView)
    }
    
    func setupConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(contentView)
            make.centerY.equalTo(self).multipliedBy(1.1)
            make.top.bottom.equalTo(contentView).inset(20)
        }
    }
}
