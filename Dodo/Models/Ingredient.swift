//
//  ingredients.swift
//  Dodo
//
//  Created by Rishat Zakirov on 06.09.2024.
//

import Foundation

struct Ingredient: Codable {
    let imageName: String
    let nameOfIngredient: String
    let price: String
    let isSelected: Bool
}

extension Ingredient: CustomStringConvertible {
    var description: String {
        "\(imageName), \(nameOfIngredient), \(price), \(isSelected)"
    }
}

extension Ingredient: Equatable {
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.imageName == rhs.imageName &&
        lhs.nameOfIngredient == rhs.nameOfIngredient &&
        lhs.price == rhs.price
    }
}

extension Ingredient {
    var selected: Self {
        Ingredient(imageName: imageName, nameOfIngredient: nameOfIngredient, price: price, isSelected: !isSelected)
    }
}
