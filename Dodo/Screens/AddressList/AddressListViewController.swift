//
//  AddressListViewController.swift
//  Dodo
//
//  Created by Rishat Zakirov on 03.11.2024.
//

import UIKit

final class AddressListViewController: UIViewController {

    private let addressStorage = AddressStorage()

    private var addresses: [Address] = [] {
        didSet {
            addressTableView.reloadData()
        }
    }
    
    private lazy var addressTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.registerCell(AddressesCell.self)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fetchAdresses()
    }
    
    private func fetchAdresses() {
        addresses = addressStorage.fetch()

        print(addresses)
    }
}

extension AddressListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTableView.dequeuCell(indexPath) as AddressesCell
        cell.update(address: addresses[indexPath.row])
        return cell
    }
}

extension AddressListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addressStorage.select(index: indexPath.row)

        addresses = addressStorage.fetch()
        tableView.reloadData()
    }
}

extension AddressListViewController {
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(addressTableView)
    }
    
    private func setupConstraints() {
        addressTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
