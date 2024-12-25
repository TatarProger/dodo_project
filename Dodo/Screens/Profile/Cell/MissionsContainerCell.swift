//
//  MissionsContainerCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 22.12.2024.
//

import UIKit
class MissionsContainerCell: UITableViewCell {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 25
        layout.itemSize.height = 275
        layout.itemSize.width = 375
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.dataSource = self
        collection.delegate = self
        collection.register(MissonsCell.self, forCellWithReuseIdentifier: MissonsCell.reuseId)
        return collection
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Задания"
        label.font = UIFont(name: "Dodo Rounded", size: 25)
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

extension MissionsContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissonsCell.reuseId, for: indexPath) as! MissonsCell
        
        return cell
    }
    
    
}

extension MissionsContainerCell {
    func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(5)
            make.left.equalTo(contentView).inset(5)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.right.equalTo(contentView).inset(5)
            make.bottom.equalTo(contentView)
        }
    }
}
