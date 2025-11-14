//
//  ViewController.swift
//  Dodo
//
//  Created by Rishat Zakirov on 31.07.2024.
//

import UIKit
import SnapKit

protocol IMenuViewController {
    var presenter: IMenuPresenter? {get set}
    
    func navigateToDetailScreen(_ product: Product)
    func navigateToMapScreen()
    func navigateToProfile()
    
    func scrollToRow(_ indexPath: IndexPath)

    func update(_ products: [Product])
    func update(_ categories: [Category])
    func update(_ address: String)
}

final class MenuViewController: UIViewController, IMenuViewController {
    
    var presenter: IMenuPresenter?
    
    private var products: [Product] = []
    
    private var deliveryAddress = ""
    
    private var categories: [Category] = []
    
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
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    
}


//MARK: Display Logic
extension MenuViewController {
    func update(_ products: [Product]) {
        self.products = products
        tableView.reloadData()
        
    }
    func update(_ categories: [Category]) {
        self.categories = categories
        tableView.reloadData()
    }
    
    func update(_ address: String) {
        self.deliveryAddress = address
        tableView.reloadData()
    }
    func scrollToRow(_ indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
                cell.update(deliveryAddress)
                
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
        let product = products[rowIndex]
        presenter?.productCellSelect(product)
    }
    
    private func bannerCellSelect(_ product: Product) {
        presenter?.bannerCellSelect(product)
    }
    
    private func profileButtonTapped() {
        presenter?.profileButtonTapped()
    }
    
    private func addressButtonTapped() {
        presenter?.addressButtonTapped()
    }
    
    private func categoryCellSelected(_ section: Int) {
        let indexPath = IndexPath(row: section, section: 3)
        presenter?.categoryCellSelected(indexPath)
    }
    
}

//MARK: Navigation
extension MenuViewController {
    func navigateToDetailScreen(_ product: Product) {
        let detailController = di.screenFactory.makeDetailProductScreen(product)
        present(detailController, animated: true)
    }
    
    func navigateToMapScreen() {
        let mapController = di.screenFactory.makeMapScreen()
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






