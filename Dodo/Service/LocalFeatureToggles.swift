//
//  LocalFeatureToggles.swift
//  Dodo
//
//  Created by Rishat Zakirov on 08.01.2025.
//

import Foundation

class LocalFeatureToggles {
    
    private static var localFeatures: [String: Feature] = [:]
    
    static var isMapAvalibale: Bool {
        guard let feature = localFeatures["X-101: Map"] else {return false}
        return feature.enabled
    }
    static var isCartAvalibale: Bool {
        guard let feature = localFeatures["X-109: Cart"] else {return false}
        return feature.enabled
    }
    static var isProfileAvalibale: Bool {
        guard let feature = localFeatures["X-110: Profile"] else {return false}
        return feature.enabled
    }
    
    func fetch() -> [Feature] {
        return LocalFeatureToggles.localFeatures.values.sorted(by: {$0.name < $1.name})
    }
    
    func update(_ feature: Feature) {
        LocalFeatureToggles.localFeatures[feature.name] = feature
    }

    // Метод для чтения файла JSON
    func load() -> [Feature] {

        guard let url = Bundle.main.url(forResource: "FeatureToggles", withExtension: "json") else {
            print("Не удалось найти файл FeatureToggles.json")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(FeaturesResponse.self, from: data)
            
            for item in response.features {
                LocalFeatureToggles.localFeatures[item.name] = item
            }
            
            //return response.features
            return LocalFeatureToggles.localFeatures.values.sorted(by: {$0.name < $1.name})
        } catch {
            print("Ошибка при парсинге JSON: \(error)")
            return []
        }
    }
}


