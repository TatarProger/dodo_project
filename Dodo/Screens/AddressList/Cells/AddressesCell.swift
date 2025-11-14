//
//  AddressesCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 04.11.2024.
//

import UIKit

class AddressesCell: UITableViewCell {
    static let reuseId = "AddressesCell"
    
    let selectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        return imageView
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(address: Address) {
        addressLabel.text = address.city + ", " + address.street + ", " + String(address.numberOfBuilding)
        
        
        if address.isSelected {
            selectImageView.image = UIImage(systemName: "circle.circle.fill")
        } else {
            selectImageView.image = UIImage(systemName: "circle")
        }
    }
}

extension AddressesCell {
    func setupViews() {
        contentView.addSubview(addressLabel)
        contentView.addSubview(selectImageView)
    }
    func setupConstraints() {
        
        selectImageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(16)
                   make.left.equalTo(contentView).offset(10)
               }

        addressLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(16)
            make.left.equalTo(selectImageView.snp.right).offset(10)
        }
       
    }
}
