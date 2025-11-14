//
//  Address.swift
//  Dodo
//
//  Created by Rishat Zakirov on 03.11.2024.
//

//struct - non mutable
//class - mutable
//static - reusable

import Foundation

struct Address: Codable{
    let city: String
    let street: String
    let numberOfBuilding: String
    let numberOfFlat: Int
    let floor: Int
    let enter: Int
    let code: String
    let commentary: String
    let isSelected: Bool
}

extension Address {
    
    var toggleSelected: Address {
        return .init(city: self.city,
                     street: self.street,
                     numberOfBuilding: self.numberOfBuilding,
                     numberOfFlat: self.numberOfFlat,
                     floor: self.floor,
                     enter: self.enter,
                     code: self.code,
                     commentary: self.commentary,
                     isSelected: !self.isSelected)
    }
    
}

extension Address: Equatable {
    static func == (lhs: Address, rhs: Address) -> Bool{
        lhs.city == rhs.city &&
        lhs.street == rhs.street &&
        lhs.numberOfBuilding == rhs.numberOfBuilding
    }
}


extension Address {
    var fullAddress: String {
        "\(city), \(street), \(numberOfBuilding)"
    }
}
