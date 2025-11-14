//
//  CategoryCollectionInCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 06.09.2024.
//

import UIKit

final class CategoriesContainerCell: UITableViewCell {

    static let reuseId = "CategoriesContainerCell"
    
    var onButtonTapped: ((Int)->())?

    private var categories: [Category] = []{
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 10
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseId)
        collection.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ categories: [Category]) {
        self.categories = categories
    }
}


extension CategoriesContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseId, for: indexPath) as! CategoryCell
        cell.update(categories[indexPath.row])
        cell.onButtonTapped = {
            var section = 0
            switch indexPath.row {
            case 0:
                section = 0
            case 1:
                section = 47
            case 2:
                section = 3
            case 3:
                section = 15
            case 4:
                section = 20
            case 5:
                section = 26
            case 6:
                section = 29
            default:
                section = 0
            }
            self.onButtonTapped?(section)
        }
        return cell
    }
}

extension CategoriesContainerCell {
    private func setupViews() {
        contentView.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
