//
//  ScreenFactory.swift
//  Dodo
//
//  Created by Rishat Zakirov on 27.11.2024.
//

import Foundation

protocol IScreenFactory {
    func makeMenuScreen() -> MenuViewController
    func makeCartScreen() -> CartViewController
    func makeDetailProductScreen(_ product: Product) -> DetailProductController
    func makeMapScreen() -> MapViewController
}

class ScreenFactory: IScreenFactory {
    
    weak var di: DI!

    func makeMenuScreen() -> MenuViewController {
        let menuVC = MenuViewController()
        let presenter = MenuPresenter.init(productService: di.productService, categoryService: di.categoryService, addressStorage: di.addressStorage, featureToggleStorage: di.featureToggleStorage)
        
        menuVC.presenter = presenter
        presenter.view = menuVC

        return menuVC
    }
    
    func makeCartScreen() -> CartViewController {
        let cartVC = CartViewController(cartStorage: di.cartStorage, productService: di.productService)
        return cartVC
    }
    
    func makeDetailProductScreen(_ product: Product) -> DetailProductController {
        let detailProductVC = DetailProductController(cartStorage: di.cartStorage, ingredientService: di.ingredientService)
        detailProductVC.update(product)
        return detailProductVC
    }
    
    func makeMapScreen() -> MapViewController {
        let mapVC = MapViewController()
        return mapVC
    }
}
