//
//  StoriesCollectionView.swift
//  Dodo
//
//  Created by Rishat Zakirov on 31.08.2024.
//

import UIKit

final class StoriesContainerCell: UITableViewCell {

    static let reusedId = "StoriesContainerCell"
    
    private lazy var collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 125, height: 150)
        
        let colletion = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colletion.heightAnchor.constraint(equalToConstant: 160).isActive = true
        colletion.dataSource = self
        colletion.delegate = self

        colletion.register(StoriesCell.self, forCellWithReuseIdentifier: StoriesCell.reusedId)
        return colletion
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

extension StoriesContainerCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoriesCell.reusedId, for: indexPath) as? StoriesCell else {return UICollectionViewCell()}
        return cell
    }
}

extension StoriesContainerCell {
    private func setupViews() {
        contentView.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
