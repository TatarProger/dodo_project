//
//  CartPresenter.swift
//  Dodo
//
//  Created by Rishat Zakirov on 05.06.2025.
//

import Foundation

protocol ICartPresenter {
    var view: ICartViewController? {get set}
}

class CartPresenter: ICartPresenter {
    var view: (any ICartViewController)?
    
    let cartStorage: ICartStorage
    let productService: IProductService
    
    init(cartStorage: ICartStorage, productService: IProductService) {
        self.cartStorage = cartStorage
        self.productService = productService
    }
}


//MARK: - Business Logic
extension CartPresenter {
    func fetchAdditionsFromApi() {
        productService.fetchProducts { result in
            switch result {
            case .success(let products):
                self.view?.additions = products
            case .failure(let error):
                print(error)
            }
        }
    }
}
