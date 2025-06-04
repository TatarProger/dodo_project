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
        let address = addressStorage.fetchDefaultAddress()
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
    }
}

//MARK: - Business Logic
extension MenuPresenter {
    
    private func fetchCategories() {
        
        categoryService.fetchCategories { [weak self] result in
            switch result {
            case .success(let categories):
                
                self?.view?.update(categories)
                //self.categories = category
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    private func fetchProducts() {
        productService.fetchProducts { result in
            switch result {
                
            case .success(let products):
                //self.products = product
                self.view?.update(products)
            case .failure(let error):
                print(error)
            }
        }
    }
}
