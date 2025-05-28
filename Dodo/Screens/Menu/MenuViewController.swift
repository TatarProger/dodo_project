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
    private let addressStorage: IAdressStorage
    private let featureToggleStorage: IFeatureToggleStorage
    
    init(productService: IProductService, categoryService: ICategoryService, addressStorage: IAdressStorage, featureToggleStorage: IFeatureToggleStorage) {
        self.productService = productService
        self.categoryService = categoryService
        self.addressStorage = addressStorage
        self.featureToggleStorage = featureToggleStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var products: [Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var categories: [Category] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy  var tableView: UITableView = {
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
    
    private func fetchCategories() {
        
        categoryService.fetchCategories { result in
            switch result {
            case .success(let category):
                
                self.categories = category
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    private func fetchProducts() {
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
                    self.categoryCellSelected(section)
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
                
                cell.onAddressButtonTapped = {
                    self.addressButtonTapped()
                }
                cell.onProfileButtonTapped = {
                    self.profileButtonTapped()
                }
                cell.configure()
                
                return cell
            case .stories:
                let cell = tableView.dequeuCell(indexPath) as StoriesContainerCell
                return cell
                
            case .banners:
                let cell = tableView.dequeuCell(indexPath) as BannersContainerCell
                
                cell.update(products)
                
                cell.onBannerSelected = { product, row in
                    self.bannerCellSelect(product)
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
                productCellSelect(indexPath.row)
                
            default:
                break
            }
        }
    }
}

//MARK: Event Handler
extension MenuViewController {
    
    private func productCellSelect(_ rowIndex: Int) {
        print("cell selected")
        let product = products[rowIndex]
        navigateToDetailScreen(product)
    }
    
    private func bannerCellSelect(_ product: Product) {
        self.navigateToDetailScreen(product)
    }
    
    private func profileButtonTapped() {
        self.navigateToProfile()
    }
    
    private func addressButtonTapped() {
        self.navigateToMapScreen()
    }
    
    private func categoryCellSelected(_ section: Int) {
        tableView.scrollToRow(at: IndexPath(row: section, section: 3), at: .top, animated: true)
    }
    
    
}

//MARK: Navigation
extension MenuViewController {
    private func navigateToDetailScreen(_ product: Product) {
        let detailController = di.screenFactory.makeDetailProductScreen(product)
        present(detailController, animated: true)
    }
    
    private func navigateToMapScreen() {
        let mapController = ScreenFactory().makeMapScreen()
        present(mapController, animated: true)
    }
    
    private func navigateToProfile() {
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






