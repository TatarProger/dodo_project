//
//  CollectionViewInCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 26.08.2024.
//

import UIKit
final class BannersContainerCell: UITableViewCell {

    var onBannerSelected:((Product, Int) -> ())?

    private var products: [Product] = []{
        didSet {
            someCollectionView.reloadData()
        }
    }
    
    static let reusedId = "BannersContainerCell"
    
    private let label: UILabel = {
        var label = UILabel()
        label.text = "Выгодно и вкусно"
        label.font = UIFont(name: "Dodo Rounded", size: 20)
        return label
    }()
    
    private lazy var someCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 100)
        
        collection.heightAnchor.constraint(equalToConstant: 150).isActive = true
        collection.backgroundColor = .systemBackground
        collection.dataSource = self
        collection.delegate = self
        collection.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

        collection.register(BannerCollectionCell.self, forCellWithReuseIdentifier: BannerCollectionCell.reusedId)
        
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
    
    func update(_ products: [Product]) {
        self.products = products
    }
}

extension BannersContainerCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionCell.reusedId, for: indexPath) as? BannerCollectionCell else { return UICollectionViewCell() }
        let product = products[indexPath.row]
        cell.update(product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("banner is selected")
        onBannerSelected?(products[indexPath.row], indexPath.row)
    }
    
}

extension BannersContainerCell {
    private func setupViews() {
        contentView.addSubview(someCollectionView)
        contentView.addSubview(label)
    }
    
    private func setupConstraints() {
        someCollectionView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView.safeAreaLayoutGuide)
            make.top.equalTo(label).offset(15)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.left.equalTo(contentView).offset(10)
        }
    }
}
