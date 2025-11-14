//
//  ProductTittleView.swift
//  Dodo
//
//  Created by Rishat Zakirov on 13.09.2024.
//

import UIKit

class ProductTitleView: UIView {
    
    var onCloseButtonTapped: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let containerView: UIView = {
        let view = UIView()
        view.addBlur(style: .light)
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: configuration), for: .normal)
        button.tintColor = .black
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        
        button.addTarget(nil, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func closeButtonTapped() {
        onCloseButtonTapped?()
    }
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Маргарита"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    func update(scrollValue: CGFloat) {
        
        if scrollValue >= 0 || scrollValue <= 100 {
            let alphaValue = scrollValue / 100
            containerView.alpha = alphaValue
            var fontSizeValue = 20 - 5 * alphaValue
            if fontSizeValue < 16 {
                fontSizeValue = 16
            }
            titleLabel.font = UIFont.boldSystemFont(ofSize: fontSizeValue)
        }
       
    }
    
    func updateLabel(_ product: Product?) {
        titleLabel.text = product?.name ?? ""
    }
}

extension ProductTitleView {
    private func setupViews() {
        addSubview(containerView)
        self.addSubview(closeButton)
        self.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(self).multipliedBy(1.3)
            make.left.equalTo(self).offset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).multipliedBy(1.5)
        }
    }
}


