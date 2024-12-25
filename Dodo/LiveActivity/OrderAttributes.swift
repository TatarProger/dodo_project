//
//  OrderAttributes.swift
//  Dodo
//
//  Created by Rishat Zakirov on 24.11.2024.
//

import Foundation
public protocol ActivityAttributes: Codable {
    associatedtype ContentState: Decodable, Encodable, Hashable
}


struct OrderAttributes: ActivityAttributes {
    
    struct ContentState: Codable, Hashable {
        enum OrderStatus: Float, Codable, Hashable {
            case inQueue = 0
            case aboutToTake
            case making
            case ready
            
            var description: String {
                switch self {
                case .inQueue:
                    return "Your order is in the queue"
                case .aboutToTake:
                    return "We're about to take your order"
                case .making:
                    return "We're preparing your order"
                case .ready:
                    return "Your order is ready to pick up!"
                }
            }
        }
        let status: OrderStatus
    }
    let orderNumber: Int
}
