//
//  ScreenFactory.swift
//  Dodo
//
//  Created by Rishat Zakirov on 27.11.2024.
//

import Foundation
//protocol IScreenFactory {
//    
//    func makeMenuScreen() -> MenuViewController
//}

class ScreenFactory {
    
    weak var di: DI!

    func makeMenuScreen() -> MenuViewController {
        
        let menuVC = MenuViewController(productService: di.productService, categoryService: di.categoryService)
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
