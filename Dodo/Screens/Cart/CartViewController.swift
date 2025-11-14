////
////  ShoppingCartViewController.swift
////  Dodo
////
////  Created by Rishat Zakirov on 07.08.2024.
////

import UIKit
import SnapKit

// MARK: — Состояние корзины
enum CartState: Equatable {
    case idle
    case loading
    case ready(products: [Product], additions: [Product])
    case empty
    case error(String)
}

// MARK: — Вспомогательный вью: скелетон
final class SkeletonView: UIView {
    private var gradientLayer: CAGradientLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = .clear
        startShimmer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startShimmer() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = bounds
        gradient.locations = [0.0, 0.5, 1.0]

        layer.addSublayer(gradient)
        gradientLayer = gradient

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2
        animation.repeatCount = .infinity

        gradient.add(animation, forKey: "shimmer")
    }

    func stopShimmer() {
        gradientLayer?.removeAllAnimations()
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}

// MARK: — Контроллер
final class CartViewController: UIViewController {

    private let cartStorage: ICartStorage
    private let productService: IProductService

    private let emptyCartView = EmptyCartView()
    private let shimmerView = SkeletonView() // ← заменяет спиннер

    private var state: CartState = .idle {
        didSet { update(state) }
    }

    private var additions: [Product] = [] { didSet { tableView.reloadData() } }
    private var products: [Product] = [] { didSet { tableView.reloadData() } }

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

    init(cartStorage: ICartStorage, productService: IProductService) {
        self.cartStorage = cartStorage
        self.productService = productService
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCart()
    }
}

// MARK: — Бизнес-логика со стейт-машиной
extension CartViewController {

    private func loadCart() {
        state = .loading

        let group = DispatchGroup()
        var loadedProducts: [Product] = []
        var loadedAdditions: [Product] = []
        var loadError: String?

        group.enter()
        DispatchQueue.global().async {
            let items = self.cartStorage.fetch()
            loadedProducts = items
            group.leave()
        }

        group.enter()
        self.productService.fetchProducts { result in
            switch result {
            case .success(let items): loadedAdditions = items
            case .failure(let err): loadError = err.localizedDescription
            }
            group.leave()
        }

        group.notify(queue: .main) {
            if let e = loadError {
                self.state = loadedProducts.isEmpty
                    ? .error(e)
                    : .ready(products: loadedProducts, additions: loadedAdditions)
                return
            }
            guard !loadedProducts.isEmpty else {
                self.state = .empty
                return
            }
            self.state = .ready(products: loadedProducts, additions: loadedAdditions)
        }
    }

    private func update(_ state: CartState) {
        switch state {
        case .idle:
            shimmerView.isHidden = true
            emptyCartView.isHidden = true
            tableView.isHidden = false
            priceButton.isHidden = false

        case .loading:
            shimmerView.isHidden = false
            shimmerView.startShimmer()
            emptyCartView.isHidden = true
            tableView.isHidden = true
            priceButton.isHidden = true

        case let .ready(products, additions):
            shimmerView.isHidden = true
            shimmerView.stopShimmer()
            emptyCartView.isHidden = true
            tableView.isHidden = false
            priceButton.isHidden = false
            self.products = products
            self.additions = additions
            _ = calculateCartPrice()

        case .empty:
            shimmerView.isHidden = true
            shimmerView.stopShimmer()
            self.products = []
            self.additions = []
            tableView.isHidden = true
            priceButton.isHidden = true
            emptyCartView.isHidden = false

        case let .error(message):
            shimmerView.isHidden = true
            shimmerView.stopShimmer()
            tableView.isHidden = true
            priceButton.isHidden = true
            emptyCartView.isHidden = false
            showError(message)
        }
    }
}

// MARK: — Остальные методы (не менялись)
extension CartViewController {
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }

    private func removeInStorage(_ product: Product) {
        cartStorage.remove(product)
        loadCart()
    }

    private func appendInStorage(_ product: Product) {
        cartStorage.append(product)
        loadCart()
    }

    private func calculateCartPrice() -> String {
        var count = 0
        var totalPrice = 0
        for item in products {
            count += item.count
            totalPrice += item.price * item.count
        }
        priceButton.setTitle("Оформить заказ на \(totalPrice) р.", for: .normal)

        if products.count == 1 { return "1 товар на \(totalPrice) р." }
        if products.count > 1 && products.count < 5 { return "\(products.count) товара на \(totalPrice) р." }
        if products.count > 4 { return "\(products.count) товаров на \(totalPrice) р." }
        return ""
    }
}

////MARK: Navigation
extension CartViewController {
    private func navigateToDetailProduct(_ product: Product) {

        let detailVC = di.screenFactory.makeDetailProductScreen(product)
        detailVC.addProductButtonTapped = {
            self.viewWillAppear(true)
        }
        present(detailVC, animated: true)
    }
}

// MARK: — Layout
extension CartViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(cartLabelCell)
        view.addSubview(priceButton)
        view.addSubview(emptyCartView)
        view.addSubview(shimmerView)
    }

    private func setupConstraints() {
        emptyCartView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
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

        shimmerView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
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
            cartLabelCell.update(scrollValue: scrollView.contentOffset.y)
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            cartLabelCell.update(scrollValue: scrollView.contentOffset.y)
        }
    }
}
