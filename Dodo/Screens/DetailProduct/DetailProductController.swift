//
//  DetailProductController.swift
//  Dodo
//
//  Created by Rishat Zakirov on 04.09.2024.
//

import UIKit

final class DetailProductController: UIViewController {

    var addProductButtonTapped: (()->())?
    var sizeDoughOn: (()->(String, String))?
    
    private let cartStorage: ICartStorage
    private let ingredientService: IIngredientService
    private var pizzaSize: String?

    let productTitleView = ProductTitleView()

    init(cartStorage: ICartStorage, ingredientService: IIngredientService) {
        self.cartStorage = cartStorage
        self.ingredientService = ingredientService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var ingredients: [Ingredient] = [] {
        didSet {
            someTableView.reloadData()
        }
    }
    
    private var product: Product? {
        didSet {
            someTableView.reloadData()
        }
    }
    
    private var lastContentOffset: CGFloat = 0

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        view.addSidedBorder(toEdge: .top, withColor: UIColor(cgColor: CGColor(gray: 0.3, alpha: 0.2)), inset: 3, thickness: 1)
        view.backgroundColor = UIColor(cgColor: CGColor(gray: 0.05, alpha: 0.05))
        return view
    }()
    
    private lazy var someTableView: UITableView = {
        let table = UITableView()
        table.heightAnchor.constraint(equalToConstant: 150).isActive = true
        table.dataSource = self
        table.delegate = self
        table.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        table.separatorColor = .systemBackground

        table.registerCell(PhotoProductCell.self)
        table.registerCell(PizzaSizeDoughCell.self)
        table.registerCell(ProductComponentsCell.self)
        table.registerCell(PizzaIngredientsCell.self)
        return table
    }()
    
    private let priceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("В корзину за 500 р.", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 30
        button.addTarget(nil, action: #selector(priceButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fetchIngredients()
        observe()
    }
}

//MARK: - Observers
extension DetailProductController {
    private func observe() {
        productTitleView.onCloseButtonTapped = { [weak self] in
            self?.closeButtonTapped()
        }
    }
}

//MARK: - Event Handler
extension DetailProductController {
    
    private func closeButtonTapped() {
        dismiss(animated: true)
    }

    @objc
    private func priceButtonTapped() {
        addProductButtonTapped?()
        guard let product else { return }
        cartStorage.append(product)
    }
    
    private func ingredientCellSelected(_ ingredient: Ingredient) {

        if let index = self.ingredients.firstIndex(where: { $0 == ingredient }) {
            
            var ingredient = self.ingredients[index]
            ingredient = ingredient.selected

            self.product?.ingredients = []

            if ingredient.isSelected == true {
                self.product?.ingredients?.append(ingredient)
            } else {
                self.product?.ingredients?.removeAll(where:  { $0 == ingredient})
            }
            
            self.ingredients[index] = ingredient
            self.someTableView.reloadData()
        }
    }
}

//MARK: - BusinessLogic
extension DetailProductController {
    
    private func fetchIngredients(){
        ingredientService.fetchIngredients { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let ingredient):
                self.ingredients = ingredient
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Public
extension DetailProductController {
    
    func update(_ product: Product) {
        self.product = product
        productTitleView.updateLabel(product)
        priceButton.setTitle("В корзину за \(product.price) р.", for: .normal)
    }
    
}

//MARK: - Table Delegate & DataSource
extension DetailProductController: UITableViewDelegate, UITableViewDataSource {
    
    enum DetailSections: Int, CaseIterable {
        case photo
        case sizeDough
        case description
        case ingredients
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = DetailSections(rawValue: indexPath.row), let product else { return 0 }
        
            switch sectionType {
            case .sizeDough, .ingredients:
                return product.type == "pizza" ? UITableView.automaticDimension : 0
            default:
                return UITableView.automaticDimension
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let sectionType = DetailSections(rawValue: indexPath.row) {
            switch sectionType {
                
            case .photo:
                let cell = tableView.dequeuCell(indexPath) as PhotoProductCell
                cell.update(product)
                return cell
                
            case .sizeDough:
                let cell = tableView.dequeuCell(indexPath) as PizzaSizeDoughCell
                
                cell.onSizeChanged = { [weak self] size in
                    guard let self else { return }
                    self.product = self.product?.changeSize(size)
                }
                    
                cell.onDoughChanged = { [weak self] dough in
                    guard let self else { return }
                    self.product = self.product?.changeDough(dough)
                }
                
                guard let product else { return UITableViewCell() }
                
                cell.update(product)
                
                return cell
                
            case .description:
                let cell = tableView.dequeuCell(indexPath) as ProductComponentsCell
                cell.update(product)
                return cell
                
            case .ingredients:
                let cell = tableView.dequeuCell(indexPath) as PizzaIngredientsCell
                
                cell.onIngredientSelected = { [weak self] ingredient in
                    guard let self else { return }
                    self.ingredientCellSelected(ingredient)
                }
                
                cell.update(ingredients)
                
                return cell
            }
        }
        return UITableViewCell()
    }
}

//MARK: - ScrollViewDelegate
extension DetailProductController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }

    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            // did move up
            productTitleView.update(scrollValue: scrollView.contentOffset.y)
            print("-> up", scrollView.contentOffset.y)
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            // did move down
            productTitleView.update(scrollValue: scrollView.contentOffset.y)
            print("-> down", scrollView.contentOffset.y)
        } else {
            // didn't move
        }
    }
}

//MARK: - Layout
extension DetailProductController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(someTableView)
        view.addSubview(containerView)
        containerView.addSubview(priceButton)
        view.addSubview(productTitleView)
    }
    private func setupConstraints() {
        productTitleView.snp.makeConstraints { make in
            make.left.right.top.equalTo(view)
            make.height.equalTo(100)
        }
        
        someTableView.snp.makeConstraints { make in
            make.left.right.top.equalTo(view)
        }
        priceButton.snp.makeConstraints { make in
            make.edges.equalTo(containerView).inset(10)
        }
        containerView.snp.makeConstraints { make in
            make.top.equalTo(someTableView.snp.bottom)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
