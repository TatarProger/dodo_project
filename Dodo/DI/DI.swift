//
//  DI.swift
//  Dodo
//
//  Created by Rishat Zakirov on 25.10.2024.
//

import Foundation

final class DI {
    
    let productService: ProductsService
    let categoryService: CategoryService
    let cartStorage: CartStorage
    let ingredientService: IngredientService
    let locationService: LocationService
    let geocodeService: GeocodeService
    let addressStorage: AddressStorage
    let featureToggleStorage: FeatureToggleStorage
    let screenFactory: ScreenFactory

    init() {
        productService = ProductsService()
        categoryService = CategoryService()
        cartStorage = CartStorage()
        ingredientService = IngredientService()
        geocodeService = GeocodeService()
        locationService = LocationService()
        addressStorage = AddressStorage()
        
        featureToggleStorage = FeatureToggleStorage()

        screenFactory = ScreenFactory()
        screenFactory.di = self
    }
}
