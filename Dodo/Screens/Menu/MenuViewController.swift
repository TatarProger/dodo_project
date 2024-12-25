//
//  ViewController.swift
//  Dodo
//
//  Created by Rishat Zakirov on 31.07.2024.
//

import UIKit
import SnapKit

final class MenuViewController: UIViewController {
    
    private let categoryService: ICategoryService
    private let productService: IProductService
    let addressStorage = AddressStorage()
    
    init(productService: IProductService, categoryService: ICategoryService) {
        self.productService = productService
        self.categoryService = categoryService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var products: [Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var categories: [Category] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy  var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorColor = .systemBackground
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.registerCell(ProfileAddresCell.self)
        tableView.registerCell(StoriesContainerCell.self)
        tableView.registerCell(BannersContainerCell.self)
        tableView.registerHeader(CategoriesContainerHeader.self)
        tableView.registerCell(CategoriesContainerCell.self)
        tableView.registerCell(ProductCell.self)
        tableView.registerCell(PromoCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        fetchProducts()
        fetchCategories()
    }
    
}

//MARK: - Business Logic
extension MenuViewController {
    
    func fetchCategories() {
        
        categoryService.fetchCategories { result in
            switch result {
            case .success(let category):
                
                self.categories = category
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func fetchProducts() {
        productService.fetchProducts { result in
            switch result {
                
            case .success(let product):
                self.products = product
            case .failure(let error):
                print(error)
            }
        }
    }
}


extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    enum MenuSections: Int, CaseIterable {
        case profileAddres
        case stories
        case banners
        case productList
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MenuSections.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionType = MenuSections(rawValue: section) {
            switch sectionType {
            case .profileAddres:
                return 1
            case .stories:
                return 1
            case .banners:
                return 1
            case .productList:
                return products.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionType = MenuSections(rawValue: section) {
            switch sectionType {
            case .productList:
                let header = tableView.dequeHeader(headerClass: CategoriesContainerHeader.self)
                header.update(categories)
                header.onButtonTapped = { section in
                    tableView.scrollToRow(at: IndexPath(row: section, section: 3), at: .top, animated: true)
                }
                return header
            default:
                return nil
            }
            
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let sectionType = MenuSections(rawValue: section) {
            switch sectionType {
            case .productList:
                return CGFloat(50)
            default:
                return 0
            }
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let sectionType = MenuSections(rawValue: indexPath.section) {
            
            switch sectionType {
            case .profileAddres:
                
                let cell = tableView.dequeuCell(indexPath) as ProfileAddresCell
                cell.update(addressStorage.fetchDefaultAddress())
                cell.onButtonTapped = {
                    self.navigateToMapScreen()
                }
                cell.onButtonTapped2 = {
                    self.navigateToProfile()
                }
                
                return cell
            case .stories:
                let cell = tableView.dequeuCell(indexPath) as StoriesContainerCell
                return cell
                
            case .banners:
                let cell = tableView.dequeuCell(indexPath) as BannersContainerCell
                
                cell.update(products)
                
                cell.onBannerSelected = { product, row in
                    self.navigateToDetailScreen(product)
                }
                
                return cell
            case .productList:
                
                let product = products[indexPath.row]
                
                if product.isPromo {
                    let cell = tableView.dequeuCell(indexPath) as PromoCell
                    cell.update(product)
                    return cell
                }
                
                let cell = tableView.dequeuCell(indexPath) as ProductCell
                cell.update(product)
                return cell
                
                
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let sectionType = MenuSections(rawValue: indexPath.section) {
            switch sectionType {
            case .productList:
                print("cell selected")
                let product = products[indexPath.row]
                print(indexPath.section, "section")
                print(indexPath.row, "row")
                navigateToDetailScreen(product)
                
            default:
                break
            }
        }
    }
}

//MARK: Navigation
extension MenuViewController {
    func navigateToDetailScreen(_ product: Product) {
        let detailController = di.screenFactory.makeDetailProductScreen(product)
        present(detailController, animated: true)
    }
    
    func navigateToMapScreen() {
        let mapController = ScreenFactory().makeMapScreen()
        present(mapController, animated: true)
    }
    
    func navigateToProfile() {
        let addController = ProfileViewController()
        present(addController, animated: true)
    }
}

//MARK: Layout
extension MenuViewController {
    
    private func setupViews () {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    private func setupConstraints () {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}






