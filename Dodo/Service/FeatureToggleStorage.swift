//
//  FeatureToggleStorage.swift
//  Dodo
//
//  Created by Rishat Zakirov on 09.01.2025.
//

import Foundation

protocol IFeatureToggleStorage {
    func fetch() -> [Feature]
    func update(_ num: Int)
    func publicSave(_ features: [Feature])
}

class FeatureToggleStorage: IFeatureToggleStorage {
    private let key = "Feature"
    
    private var userDefaults: UserDefaults
    private var encoder: JSONEncoder
    private var decoder: JSONDecoder
    
    init(userDefaults: UserDefaults = UserDefaults.standard, encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }
}

extension FeatureToggleStorage {
    private func save(_ features: [Feature]) {
        do {
            let data = try encoder.encode(features)
            userDefaults.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
}

extension FeatureToggleStorage {
    func fetch() -> [Feature] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        do {
            let features = try decoder.decode([Feature].self, from: data)
            return features
        } catch {
            print(error)
        }
        return []
    }
    
    func update(_ num: Int) {
        var features = fetch()
        features[num] = features[num].toggleEnabled
        save(features)
    }
    
    func publicSave(_ features: [Feature]) {
        save(features)
    }
}


