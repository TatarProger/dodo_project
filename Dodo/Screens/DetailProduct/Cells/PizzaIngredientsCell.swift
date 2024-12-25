//
//  PizzaIngredientsCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 04.09.2024.
//

import UIKit
class PizzaIngredientsCell: UITableViewCell {
    
    //static let reuseId = "PizzaIngredientsCell"
    
    //let ingredientService = IngredientService()
    var onIngredientSelected: ((Ingredient)->())?
    var ingredients: [Ingredient] = []{
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.itemSize = CGSize(width: 100, height: 180)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(IngredientCollectionCell.self, forCellWithReuseIdentifier: IngredientCollectionCell.reuseId)
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        //fetchIngredients()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ ingredients: [Ingredient]) {
        self.ingredients = ingredients
    }
}


extension PizzaIngredientsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCollectionCell.reuseId, for: indexPath) as! IngredientCollectionCell
        let ingredient = ingredients[indexPath.row]
        cell.update(ingredient)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ingredient = ingredients[indexPath.row]
        onIngredientSelected?(ingredient)
        
    }
}



extension PizzaIngredientsCell {
    func setupViews() {
        selectionStyle = .none
        contentView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
            make.height.equalTo(500)
            make.width.equalTo(300)
        }
    }
}
