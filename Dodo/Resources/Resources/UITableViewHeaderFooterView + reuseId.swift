//
//  UITableViewHeaderFooterView + reuseId.swift
//  Dodo
//
//  Created by Rishat Zakirov on 24.11.2024.
//

import UIKit

extension UITableViewHeaderFooterView: Reusable {}

extension Reusable  where Self: UITableViewHeaderFooterView {
    static var reuseId: String {
        return String.init(describing: self)
    }
}
