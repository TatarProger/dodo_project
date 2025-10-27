//
//  CartCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 07.08.2024.
//

import UIKit


class CartCell: UITableViewCell {
    static let reuseId = "CartCell"
    let keyValueLabel = KeyValueLabel()
    
    var onProductCountIncrease: ((Product)->())?
    var onProductCountDecrease: ((Product)->())?
    
    var product: Product?
    
    private var containerView: UIView = {
        $0.backgroundColor = .white
        $0.applyShadow(cornerRadius: 10)
        return $0
    }(UIView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
        setupStepper()
    }
    
    var stepperView: CustomStepper = {
        let stepper = CustomStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        
        return stepper
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.image = UIImage(named: "")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let labelView = UILabel()
        
        labelView.text = "pizza"
        labelView.font = UIFont(name: "Dodo Rounded", size: 20)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.numberOfLines = 0
        return labelView
    }()
    
    let descriptionLabel = KeyValueLabel()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        
        label.text = "100 р."
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ product: Product) {
        print("->", product.count)
        self.product = product
        nameLabel.text = product.name
        
        let value = product.type == "pizza" ? "\(product.size), \(product.dough), \n+\(product.ingredients ?? [])" : ""
        descriptionLabel.update(key: product.detail ?? "", value: value)
        priceLabel.text = "\(product.price) р."
        photoImageView.image = UIImage(named: product.image)
        
        stepperView.currentValue = product.count
    }
    
    private func setupStepper() {
        
        
        stepperView.addTarget(self, action: #selector(stepperChangedValueAction), for: .touchUpInside)
    }
    
    @objc private func stepperChangedValueAction(sender: CustomStepper) {
        print(sender)
        print(sender.currentValue)
        
        guard let isIncreaseValue = sender.isIncreaseValue else { return }
        
        guard let product else { return }
        
        switch isIncreaseValue {
        
        case true:
            onProductCountIncrease?(product)
            
        case false:
            onProductCountDecrease?(product)
        }
    }
    
}


extension CartCell {
    func setupViews() {
        
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(photoImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(stepperView)
        containerView.addSubview(priceLabel)
    }
    
    func setupConstraints() {
        
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.top.left.equalTo(containerView).offset(15)
        }
 
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(15)
            make.left.equalTo(photoImageView.snp.right).offset(30)
            make.right.equalTo(containerView).inset(10)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalTo(photoImageView.snp.right).offset(30)
            make.right.equalTo(containerView).inset(10)
        }

        stepperView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.right.bottom.equalTo(containerView).offset(-10)
        }

        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(containerView).offset(10)
            make.bottom.equalTo(containerView).inset(10)
        }
    }
}
