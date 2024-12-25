//
//  DI.swift
//  Dodo
//
//  Created by Rishat Zakirov on 25.10.2024.
//

import Foundation

//Dependency Container
class DI {
    
    let productService: ProductsService
    let categoryService: CategoryService
    let cartStorage: CartStorage
    let ingredientService: IngredientService
    let locationService: LocationService
    let geocodeService: GeocodeService
    let screenFactory: ScreenFactory
    
    //locationService
    //geolocationSerivce
    //decoder
    //urlSession
    
    init() {
        
        screenFactory = ScreenFactory()
        
       
        
        productService = ProductsService()
        categoryService = CategoryService()
        cartStorage = CartStorage()
        ingredientService = IngredientService()
       
        geocodeService = GeocodeService()
        locationService = LocationService()
        
        screenFactory.di = self
        
        
    }
}
