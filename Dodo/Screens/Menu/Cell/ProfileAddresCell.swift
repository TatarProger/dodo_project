//
//  ProfileAddresCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 02.10.2024.
//

import UIKit
class ProfileAddresCell: UITableViewCell {
    
    static let reuseId = "ProfileAddresCell"
    
    var onButtonTapped: (()->())?
    var onButtonTapped2: (()->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var profileButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .purple
        button.addTarget(nil, action: #selector(transitToAdd), for: .touchUpInside)
        return button
    }()
    
    var addresButton: UIButton = {
        //let button = UIButton()
        
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 20)//UIFont(name: "", size: 10)
        //titleContainer.foregroundColor = .black
        titleContainer.foregroundColor = .black
        titleContainer.backgroundColor = .black
        titleContainer.strokeColor = .yellow
        //titleContainer.color
        
        var subtitleContainer = AttributeContainer()
        subtitleContainer.font = UIFont.systemFont(ofSize: 15)//UIFont(name: "", size: 10)
        subtitleContainer.foregroundColor = .black
        
        var config = UIButton.Configuration.plain()
        
        
        
        //button.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        button.widthAnchor.constraint(equalToConstant: 250).isActive = true
//        button.layer.cornerRadius = 20
//        button.backgroundColor = .green
//        button.setTitle("Укажите адрес", for: .normal)
//        button.configuration = config
//        config.title = "Девятаева 7 ∨"
//        config.subtitle = "Около 35 минут"
        
        //config.baseBackgroundColor = .systemPink
        //config.baseForegroundColor = .black
        //config.image = UIImage(systemName: "figure.walk.circle")
        //config.imagePadding = 6
        config.attributedTitle = AttributedString("Девятаева 7 ∨", attributes: titleContainer)
        config.attributedSubtitle = AttributedString("Около 35 минут", attributes: subtitleContainer)
        //button.configuration = config
        
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(transitToMap), for: .touchUpInside)
        return button
    }()
    
    @objc func transitToMap() {
        onButtonTapped?()
    }
    @objc func transitToAdd() {
        onButtonTapped2?()
    }
    
    func update(_ addressName: String) {
        addresButton.setTitle(addressName, for: .normal)
    }
}

extension ProfileAddresCell {
    func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(profileButton)
        containerView.addSubview(addresButton)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        profileButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(containerView)
            make.right.equalTo(containerView).inset(10)
        }
        addresButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(containerView)
            make.left.equalTo(containerView).offset(10)
        }
    }
}
