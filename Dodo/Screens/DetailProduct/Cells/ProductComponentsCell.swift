//
//  ProductComponentsCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 04.09.2024.
//

import UIKit
class ProductComponentsCell: UITableViewCell {
    //static let reuseId = "ProductComponentsCell"
    
    
    let containerView: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 20
        container.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return container
    }()
    
    let descriptionComponentsLabel: UILabel = {
        let label = UILabel()
        label.text = "30 см, традиционное тесто 30, 470 г Моцарелла, сыры чеддер и пармезан, фирменный соус альфредо"
        label.font = UIFont(name: "Open Sans", size: 18)
        label.numberOfLines = 0
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
    
    func update(_ product: Product?) {
        
        descriptionComponentsLabel.text = product?.detail ?? ""
    }
}




extension ProductComponentsCell {
    func setupViews() {
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.addSubview(descriptionComponentsLabel)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(20)
        }
        descriptionComponentsLabel.snp.makeConstraints { make in
            make.edges.equalTo(containerView).inset(20)
        }
    }
}
