//
//  MenuPresenter.swift
//  Dodo
//
//  Created by Rishat Zakirov on 04.06.2025.
//

import UIKit
protocol IMenuPresenter {
    var view: IMenuViewController? {get set}
    
    func profileButtonTapped()
    
    func addressButtonTapped()
    
    func bannerCellSelect(_ product: Product)
    
    func productCellSelect(_ product: Product)
    
    func categoryCellSelected(_ indexPath: IndexPath)
    
    func viewDidLoad()
    
    func viewWillAppear()
   
}

class MenuPresenter: IMenuPresenter {
    var view: IMenuViewController?

    private let categoryService: ICategoryService
    private let productService: IProductService
    private let addressStorage: IAdressStorage
    private let featureToggleStorage: IFeatureToggleStorage
    
    init(productService: IProductService, categoryService: ICategoryService, addressStorage: IAdressStorage, featureToggleStorage: IFeatureToggleStorage) {
        self.productService = productService
        self.categoryService = categoryService
        self.addressStorage = addressStorage
        self.featureToggleStorage = featureToggleStorage
    }
    
    func viewWillAppear() {
        let address = addressStorage.fetchSelectedAddress()
        view?.update(address)
    }
    
}

//MARK: Event Handler
extension MenuPresenter {

    func profileButtonTapped() {
        view?.navigateToProfile()
    }

    func addressButtonTapped() {
        view?.navigateToMapScreen()
    }

    func bannerCellSelect(_ product: Product) {
        view?.navigateToDetailScreen(product)
    }

    func productCellSelect(_ product: Product) {
        view?.navigateToDetailScreen(product)
    }

    func categoryCellSelected(_ indexPath: IndexPath) {
        view?.scrollToRow(indexPath)
    }

    func viewDidLoad() {
        fetchCategories()
        fetchProducts()
        setupObservers()
    }
}

//MARK: - Business Logic
extension MenuPresenter {

    private func setupObservers() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addressChanged(_:)),
            name: .addressChanged,
            object: nil
        )
    }

    @objc private func addressChanged(_ notification: Notification) {
           // Если нужно получить адрес:
           if let address = notification.userInfo?["address"] as? String {
               
               print("Новый адрес: \(address)")
               view?.update(address)

           }

           // Вызвать логику, которая обычно в viewWillAppear
           // НЕ обязательно дергать сам viewWillAppear,
           // лучше вынести код в отдельный метод

       }

    private func fetchCategories() {
        
        categoryService.fetchCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.view?.update(categories)
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    private func fetchProducts() {
        productService.fetchProducts { result in
            switch result {
                
            case .success(let products):
                self.view?.update(products)
            case .failure(let error):
                print(error)
            }
        }
    }
}
