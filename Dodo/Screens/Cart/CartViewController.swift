//
//  ShoppingCartViewController.swift
//  Dodo
//
//  Created by Rishat Zakirov on 07.08.2024.
//

import UIKit
import SnapKit

protocol ICartViewController {
    var presenter: ICartPresenter? { get set }
    var additions: [Product] { get set }
}

final class CartViewController: UIViewController {

    private let cartStorage: ICartStorage
    private let productService: IProductService

    init(cartStorage: ICartStorage, productService: IProductService) {
        self.cartStorage = cartStorage
        self.productService = productService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var additions: [Product] = []{
        didSet{
            tableView.reloadData()
        }
    }
    private var products: [Product] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    private var lastContentOffset: CGFloat = 0
    private let cartLabelCell = CartPriceView()

    private let priceButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .orange
        button.layer.cornerRadius = 25
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(CartCell.self)
        tableView.registerCell(AdditionsCell.self)
        tableView.registerCell(TotalPriceCell.self)
        tableView.separatorColor = .white
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProductsFromStorage()
        fetchAdditionsFromApi()
    }
    
}

//MARK: Event Handler
extension CartViewController {
    
}

//MARK: - Business Logic
extension CartViewController {
    
    private func fetchProductsFromStorage() {
        self.products = cartStorage.fetch()
    }
    
    private func removeInStorage(_ product: Product) {
        self.cartStorage.remove(product)
        self.fetchProductsFromStorage()
    }
    
    private func appendInStorage(_ product: Product) {
        self.cartStorage.append(product)
        self.fetchProductsFromStorage()
    }
    
    private func calculateCartPrice() -> String {
        var count = 0
        var totalPrice = 0
        for item in products {
            count += item.count
            totalPrice += item.price * item.count
        }
        
        priceButton.setTitle("Оформить заказ на \(totalPrice) р.", for: .normal)
        
        if products.count == 1 {
            return "1 товар на \(totalPrice) р."
        }
        if products.count > 1 && products.count < 5 {
            return "\(products.count) товара на \(totalPrice) р."
        }
        if products.count > 4 {
            return "\(products.count) товаров на \(totalPrice) р."
        }
        
        return ""
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    enum CartSection: Int, CaseIterable {
        case totalPrice
        case products
        case additions
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CartSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfSection = CartSection(rawValue: section) {
            switch numberOfSection {
            case .totalPrice:
                return 1
            case .products:
                return products.count
            case .additions:
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let numberOfSection = CartSection(rawValue: indexPath.section) {
            switch numberOfSection {

            case .totalPrice:
                let cell = tableView.dequeuCell(indexPath) as TotalPriceCell
                
                cell.update(calculateCartPrice())
                return cell
            case .products:
                let cell  = tableView.dequeuCell(indexPath) as CartCell
                let product = products[indexPath.row]
                cell.update(product)
                
                cell.onProductCountDecrease = { product in
                    self.removeInStorage(product)
                }
                cell.onProductCountIncrease = { product in
                    self.appendInStorage(product)
                }
                
                return cell
                
            case .additions:
                let cell = tableView.dequeuCell(indexPath) as AdditionsCell

                cell.update(additions)
                cell.onAdditionCellSelected = { addition, row in
                        self.navigateToDetailProduct(addition)
                }
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
 
}

//MARK: ScrollViewDelegate
extension CartViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            // did move up
            cartLabelCell.update(scrollValue: scrollView.contentOffset.y)
            //print("-> up", scrollView.contentOffset.y)
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            // did move down
            cartLabelCell.update(scrollValue: scrollView.contentOffset.y)
            //print("-> down", scrollView.contentOffset.y)
        } else {
            // didn't move
        }
    }
}

//MARK: Business Logic
extension CartViewController {
    private func fetchAdditionsFromApi() {
        productService.fetchProducts { result in
            switch result {
            case .success(let products):
                self.additions = products
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: Navigation
extension CartViewController {
    private func navigateToDetailProduct(_ product: Product) {

        let detailVC = di.screenFactory.makeDetailProductScreen(product)
        detailVC.addProductButtonTapped = {
            self.viewWillAppear(true)
        }
        present(detailVC, animated: true)
    }
}

//MARK: Layout
extension CartViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(cartLabelCell)
        view.addSubview(priceButton)
    }
    
    private func setupConstraints() {
        cartLabelCell.snp.makeConstraints { make in
            make.left.right.top.equalTo(view)
            make.height.equalTo(100)
        }
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        
        priceButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}
