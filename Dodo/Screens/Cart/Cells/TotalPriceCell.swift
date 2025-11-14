//
//  TotalPriceCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 25.09.2024.
//

import UIKit
class TotalPriceCell: UITableViewCell {
    
    static let reuseId = "TotalPriceCell"
    
    private let descriptLabel: UILabel = {
       let label = UILabel()
        label.text = "1 товар на 589 р."
        label.font = UIFont.boldSystemFont(ofSize: 25)
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
}
//MARK: Public
extension TotalPriceCell {
    func update(_ totalPrice: String) {
        descriptLabel.text = totalPrice
    }
}

extension TotalPriceCell {
    private func setupViews() {
        contentView.addSubview(descriptLabel)
    }
    
    private func setupConstraints() {
        descriptLabel.snp.makeConstraints { make in
            make.top.bottom.right.equalTo(contentView)
            make.left.equalTo(contentView).offset(10)
        }
    }
}
