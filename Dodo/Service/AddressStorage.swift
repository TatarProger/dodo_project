//
//  AddressStorage.swift
//  Dodo
//
//  Created by Rishat Zakirov on 03.11.2024.
//

import Foundation

protocol IAdressStorage {
    func fetchDefaultAddress() -> String
    func fetch() -> [Address]
    func remove(_ address: Address)
    func append(_ address: Address)
    
}

final class AddressStorage: IAdressStorage {
    
    private let key = "AddressStorage"
    
    private var userDefaults: UserDefaults
    private var encode: JSONEncoder
    private var decoder: JSONDecoder
    
    init(userDefaults: UserDefaults = UserDefaults.standard, encode: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) {
        self.userDefaults = userDefaults
        self.encode = encode
        self.decoder = decoder
    }
}


//MARK: Private
extension AddressStorage {
    private func save(_ Addresses: [Address]) {
        do{
            let data = try encode.encode(Addresses)
            userDefaults.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
}

//MARK: Public
extension AddressStorage {
    func fetchDefaultAddress() -> String {
        let array = fetch()
        if !array.isEmpty {
            return array[0].fullAddress
        }
        
        return "Адрес не установлен"
    }
    
    func fetch() -> [Address] {
        guard let data = userDefaults.data(forKey: key) else {return []}
        do {
            let addresses = try decoder.decode([Address].self, from: data)
            return addresses
        } catch {
            print(error)
        }
        return []
    }
    
    func remove(_ address: Address) {
        var addresses = fetch()
        if addresses.contains(where: { Address in
            Address == address
        }) {
            addresses.remove(at: addresses.firstIndex(of: address) ?? 0)
        }
        save(addresses)
    }
    
    func append(_ address: Address) {
        
        var addresses = fetch()
        
        if addresses.isEmpty {
            addresses.append(address)
            save(addresses)
            return
        }
        
        //$0 - short hand param
        //condition?true:false - ternary operator
        
        guard !addresses.contains(address) else { 
            
            addresses.removeAll {$0 == address}
            addresses = addresses.map { return $0.isSelected ? $0.toggleSelected : $0 }
            addresses.insert(address, at: 0)
            save(addresses)
            
            return
        }  //early exit operator
        
        addresses = addresses.map { return $0.isSelected ? $0.toggleSelected : $0 }
        
        addresses.insert(address, at: 0)
        
        save(addresses)
    }
}
