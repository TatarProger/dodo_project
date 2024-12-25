//
//  AddressListViewController.swift
//  Dodo
//
//  Created by Rishat Zakirov on 03.11.2024.
//

import UIKit

class AddressListViewController: UIViewController {
    
    let addressStorage = AddressStorage()
    
    var addresses: [Address] = [] {
        didSet {
            addressTableView.reloadData()
        }
    }
    
    lazy var addressTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
//        table.register(AddressesCell.self, forCellReuseIdentifier: AddressesCell.reuseId)
        table.registerCell(AddressesCell.self)
        return table
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fetchAdresses()
    }
    
    func fetchAdresses() {
        addresses = addressStorage.fetch()
    }
}



extension AddressListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = addressTableView.dequeueReusableCell(withIdentifier: AddressesCell.reuseId, for: indexPath) as? AddressesCell else { return UITableViewCell()}
        let cell = addressTableView.dequeuCell(indexPath) as AddressesCell
        cell.update(address: addresses[indexPath.row])
        return cell
    }
    
    
}


extension AddressListViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(addressTableView)
    }
    
    func setupConstraints() {
        addressTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
