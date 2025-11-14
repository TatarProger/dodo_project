//
//  ProfileAddresCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 02.10.2024.
//

import UIKit
final class ProfileAddresCell: UITableViewCell {

    static let reuseId = "ProfileAddresCell"
    
    var onAddressButtonTapped: (()->())?
    var onProfileButtonTapped: (()->())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var profileButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .purple
        button.addTarget(nil, action: #selector(transitToAdd), for: .touchUpInside)
        return button
    }()
    
    private var addresButton: UIButton = {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 20)
        titleContainer.foregroundColor = .black
        titleContainer.backgroundColor = .black
        titleContainer.strokeColor = .yellow
        
        var subtitleContainer = AttributeContainer()
        subtitleContainer.font = UIFont.systemFont(ofSize: 15)
        subtitleContainer.foregroundColor = .black
        
        var config = UIButton.Configuration.plain()

        config.attributedTitle = AttributedString("Девятаева 7 ∨", attributes: titleContainer)
        config.attributedSubtitle = AttributedString("Около 35 минут", attributes: subtitleContainer)
        
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(transitToMap), for: .touchUpInside)
        return button
    }()
    
    @objc func transitToMap() {
        onAddressButtonTapped?()
    }
    @objc func transitToAdd() {
        onProfileButtonTapped?()
    }
    
    func update(_ addressName: String) {
        addresButton.setTitle(addressName, for: .normal)
    }
    
    func configure() {
        
        if LocalFeatureToggles.isMapAvalibale && RemoteFeatureToggles.isMapAvailable {
            addresButton.isHidden = false
        }
        else {
            addresButton.isHidden = true
        }
        
        if LocalFeatureToggles.isProfileAvalibale && LocalFeatureToggles.isProfileAvalibale {
            profileButton.isHidden = false
        }
        else {
            profileButton.isHidden = true
        }
    }
}

extension ProfileAddresCell {
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(profileButton)
        containerView.addSubview(addresButton)
    }
    
    private func setupConstraints() {
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
