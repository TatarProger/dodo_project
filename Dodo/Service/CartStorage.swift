//
//  ProductStorage.swift
//  Dodo
//
//  Created by Rishat Zakirov on 02.10.2024.


import Foundation
protocol ICartStorage {
    func fetch() -> [Product]
    func append(_ product: Product)
    func remove(_ product: Product)
}

final class CartStorage {
    
    private let key = "CartStorage"
    
    private var userDefaults: UserDefaults
    private var encoder: JSONEncoder
    private var decoder: JSONDecoder
    
    init(userDefaults: UserDefaults = UserDefaults.standard,
         encoder: JSONEncoder = JSONEncoder(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }
}

//MARK: - Private
extension CartStorage {
    private func save(_ products: [Product]) {
        do {
            let data = try encoder.encode(products)
            userDefaults.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
}

//MARK: - Public
extension CartStorage: ICartStorage {
    //READ
    func fetch() -> [Product] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        do {
            let products = try decoder.decode([Product].self, from: data)
            return products
        } catch {
            print(error)
        }
        return []
    }
    
    //DELETE/DECREASE
    func remove(_ product: Product) {
        
        var products = fetch()
        
        //update
        if let index = products.firstIndex(where: { $0 == product }) {
            let product = products[index]
            products[index] = product.decreaseCount
        } else {
            //create
            products.append(product)
        }
        
        //delete
        products.removeAll(where: { $0.count == 0 })
        
        save(products)
        
        
    }
    
    //
    
    
    //CREATE/INCREASE
    func append(_ product: Product) {
        var products = fetch()
        
        //update
        if let index = products.firstIndex(where: { $0 == product }) {
            
            let product = products[index]
            products[index] = product.increaseCount
        
        } else {
            //create
            products.append(product.increaseCount)
        }
        
        //delete
        products.removeAll(where: { $0.count == 0 })
        
        save(products)
    }
}


















