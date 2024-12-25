//
//  AdditionsCell.swift
//  Dodo
//
//  Created by Artur on 14.08.2024.
//

import UIKit
import SnapKit

class AdditionsCell: UITableViewCell {
    
    static let reuseId = "AdditionsCell"
    
    var onAdditionCellSelected: ((Product, Int) -> ())?
    
    var products: [Product] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = { 
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 270)
        //super.init(frame: .zero, collectionViewLayout: layout)
        
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AdditionsCollectionCell.self, forCellWithReuseIdentifier: AdditionsCollectionCell.reuseId)
        
        return collectionView
    }()
    
    let questionLabel: UILabel = {
       let label = UILabel()
        label.text = "Добавить к заказу?"
        label.font = UIFont.boldSystemFont(ofSize: 20)
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

extension AdditionsCell {
    func setupViews() {
        selectionStyle = .none
        contentView.addSubview(collectionView)
        contentView.addSubview(questionLabel)
    }
    func setupConstraints() {
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.right.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(5)
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(300)
        }
    }
}

extension AdditionsCell {
    func update(_ products: [Product]) {
        self.products = products
    }
}


extension AdditionsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdditionsCollectionCell.reuseId, for: indexPath) as! AdditionsCollectionCell
        
        let product = products[indexPath.row]
        
        cell.update(product)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onAdditionCellSelected?(products[indexPath.row], indexPath.row)
    }
    
    
}
