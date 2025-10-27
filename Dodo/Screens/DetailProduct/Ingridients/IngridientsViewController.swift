//
//  ViewController.swift
//  CollectionView-СписокИнгридиентов
//
//  Created by Rishat Zakirov on 07.08.2024.
//

//import UIKit
//import SnapKit
//
//final class IngridientsViewController: UIViewController {
//
//    private lazy var collectionView: UICollectionView = {
//        let itemsCount: CGFloat = 3
//        let padding: CGFloat = 2
//        let paddingCount: CGFloat = itemsCount + 1
//
//
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = padding
//        layout.minimumInteritemSpacing = padding
//
//
//        let paddingSize = paddingCount * padding
//        let cellSize = (UIScreen.main.bounds.width - paddingSize) / itemsCount
//
//        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
//        layout.itemSize = CGSize.init(width: cellSize, height: cellSize + 70)
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//
//        collectionView.dataSource = self
//        collectionView.register(IngredientCollectionCell.self, forCellWithReuseIdentifier: IngredientCollectionCell.reuseId)
//        return collectionView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupViews()
//        setupConstraints()
//    }
//}
//
//extension IngridientsViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCollectionCell.reuseId, for: indexPath) as! IngredientCollectionCell
//        cell.backgroundColor = .yellow
//        return cell
//    }
//}
//
////MARK: Layout
//extension IngridientsViewController {
//    private func setupViews() {
//        view.backgroundColor = .systemBackground
//        view.addSubview(collectionView)
//    }
//
//    private func setupConstraints() {
//        collectionView.snp.makeConstraints { make in
//            make.left.right.bottom.top.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
//}
//
//
