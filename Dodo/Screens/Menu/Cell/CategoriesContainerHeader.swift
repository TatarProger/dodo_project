//
//  CategoriesContainerHeader.swift
//  Dodo
//
//  Created by Rishat Zakirov on 17.10.2024.
//

import UIKit
class CategoriesContainerHeader: UITableViewHeaderFooterView {
    static let reuseId = "CategoriesContainerHeader"
    
    var onButtonTapped: ((Int)->())?
    
    //let categoryService = CategoryService()
    var categories: [Category] = []{
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
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
    
    
//    func fetchCategories(){
//        categories = categoryService.fetchCategories()
//    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
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

extension CategoriesContainerHeader: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension CategoriesContainerHeader {
    func setupViews() {
        contentView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
