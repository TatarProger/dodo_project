//
//  PersonalOffersContainerCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 22.12.2024.
//

import UIKit
class PersonalOffersContainerCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectioView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 25
        layout.itemSize.height = 165
        layout.itemSize.width = 300
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        
        collection.register(PersonalOffersCell.self, forCellWithReuseIdentifier: PersonalOffersCell.reuseId)
        return collection
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Персональные предложения"
        label.textColor = .black
        label.font = UIFont(name: "Dodo Rounded", size: 25)
        return label
    }()
}

extension PersonalOffersContainerCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalOffersCell.reuseId, for: indexPath) as! PersonalOffersCell
        return cell
    }
}

extension PersonalOffersContainerCell {
    private func setupViews() {
        contentView.addSubview(collectioView)
        contentView.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).inset(5)
        }
        
        collectioView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel).inset(5)
            make.left.right.equalTo(contentView).inset(5)
            make.bottom.equalTo(contentView)
        }
    }
}
