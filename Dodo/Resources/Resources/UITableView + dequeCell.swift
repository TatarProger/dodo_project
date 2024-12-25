//
//  UiTableView + dequeCell.swift
//  Dodo
//
//  Created by Rishat Zakirov on 16.11.2024.
//

import UIKit
extension UITableView {
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseId)
    }
    
    func dequeuCell<Cell: UITableViewCell>(_ indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: Cell.reuseId, for: indexPath) as? Cell
        else { fatalError("Fatal error for cell at \(indexPath)") }
        
        return cell
    }
}

