//
//  UiTableViewCell + reuseId.swift
//  Dodo
//
//  Created by Rishat Zakirov on 16.11.2024.
//

import UIKit

protocol Reusable {}

extension UITableViewCell: Reusable {}

extension Reusable where Self: UITableViewCell {
    
    static var reuseId: String {
        return String.init(describing: self)
    }
}
