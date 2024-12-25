//
//  ingredients.swift
//  Dodo
//
//  Created by Rishat Zakirov on 06.09.2024.
//

import Foundation

struct Ingredient: Codable, CustomStringConvertible {
    var imageName: String
    var nameOfIngredient: String
    var price: String
    var isSelected: Bool
    
    var description: String {
        return nameOfIngredient
    }
}

extension Ingredient: Equatable {
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.imageName == rhs.imageName &&
        lhs.nameOfIngredient == rhs.nameOfIngredient &&
        lhs.price == rhs.price
    }
    
     
}
