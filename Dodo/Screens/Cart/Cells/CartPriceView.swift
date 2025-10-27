//
//  CartLabelCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 26.09.2024.
//

import UIKit
class CartPriceView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.addBlur(style: .light)
        return view
    }()
    
    private var cartLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
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
    
    func update(scrollValue: CGFloat) {
            print("-> scroll", scrollValue)
            containerView.alpha = scrollValue
    }

}

//MARK: LAYOUT
extension CartPriceView {
    private func setupViews() {
        self.addSubview(containerView)
        containerView.addSubview(cartLabel)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        cartLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).multipliedBy(1.5)
        }
    }
}
