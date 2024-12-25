//
//  Product.swift
//  Dodo
//
//  Created by Rishat Zakirov on 31.07.2024.
//

import Foundation

struct Product: Decodable, Encodable {
        
    let id: Int
    let name: String
    let count: Int
    let detail: String?
    let price: Int
    let image: String
    let type: String
    let isPromo: Bool
    let size: String
    let dough: String
    var ingredients: [Ingredient]? = []
    
    var increaseCount: Self {
        let count = count + 1
        return .init(id: id, name: name, count: count, detail: detail, price: price, image: image, type: type, isPromo: isPromo, size: size, dough: dough, ingredients: ingredients)
    }
    
    var decreaseCount: Self {
        let count = count - 1
        return .init(id: id, name: name, count: count, detail: detail, price: price, image: image, type: type, isPromo: isPromo, size: size, dough: dough, ingredients: ingredients)
    }
    
    func changeSize(_ newValue: String) -> Self {
        return .init(id: id, name: name, count: count, detail: detail, price: price, image: image, type: type, isPromo: isPromo, size: newValue, dough: dough, ingredients: ingredients)
    }
    
    func changeDough(_ newValue: String) -> Self {
        return .init(id: id, name: name, count: count, detail: detail, price: price, image: image, type: type, isPromo: isPromo, size: size, dough: newValue, ingredients: ingredients)
    }

}

extension Product: Equatable {
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id && 
        lhs.name == rhs.name &&
        lhs.detail == rhs.detail &&
        lhs.price == rhs.price &&
        lhs.image == rhs.image &&
        lhs.type == rhs.type &&
        lhs.isPromo == rhs.isPromo &&
        lhs.size == rhs.size &&
        lhs.dough == rhs.dough
    }
}
