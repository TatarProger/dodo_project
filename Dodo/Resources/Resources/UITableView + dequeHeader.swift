//
//  UITableView + dequeHeader.swift
//  Dodo
//
//  Created by Rishat Zakirov on 24.11.2024.
//

import UIKit
extension UITableView {
    func registerHeader<Header: UITableViewHeaderFooterView> (_ headerClass: Header.Type) {
        register(headerClass, forHeaderFooterViewReuseIdentifier: headerClass.reuseId)
    }
    
    func dequeHeader<Header: UITableViewHeaderFooterView>(headerClass: Header.Type) -> Header {
        guard let header = self.dequeueReusableHeaderFooterView(withIdentifier: headerClass.reuseId) as? Header else
        {fatalError("Fatal error for header with reuseId: \(headerClass.reuseId)")}
        
        return header
    }
}
