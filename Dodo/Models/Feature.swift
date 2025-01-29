//
//  Feature.swift
//  Dodo
//
//  Created by Rishat Zakirov on 08.01.2025.
//

import Foundation
struct Feature: Codable {
    let name: String
    let enabled: Bool
}

struct FeaturesResponse: Codable {
    let features: [Feature]
}


extension Feature {
    var toggleEnabled: Feature {
        return .init(name: self.name, enabled: !self.enabled)
    }
}

