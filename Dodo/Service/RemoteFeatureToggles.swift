//
//  RemoteFeatureToggles.swift
//  Dodo
//
//  Created by Rishat Zakirov on 15.01.2025.
//

import Foundation


//if RemoteFeatureToggles.isMapAvailable {
//
//}

class RemoteFeatureToggles {
    
    private static var remoteFeatures: [String: Feature] = [:]
    
    static var isMapAvailable: Bool {
        guard let feature = remoteFeatures["X-101: Map"] else { return false }
        return feature.enabled
    }
    
    static var isCartAvailable: Bool {
        guard let feature = remoteFeatures["X-109: Cart"] else { return false }
        return feature.enabled
    }
    
    static var isProfileAvailable: Bool {
        guard let feature = remoteFeatures["X-110: Profile"] else { return false }
        return feature.enabled
    }
    
    func fetch() -> [Feature] {
        RemoteFeatureToggles.remoteFeatures.values.sorted(by: {$0.name < $1.name})
    }
    
    func fetchJSON( completion: @escaping ([Feature]) -> Void) {
        guard let url = URL(string: "http://localhost:3001/featureToggles") else {
            print("Неверный URL: http://localhost:3001/featureToggles")
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка загрузки данных: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("Данные отсутствуют")
                completion([])
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(FeaturesResponse.self, from: data)
                print(decodedResponse.features)
                
                for item in decodedResponse.features {
                    RemoteFeatureToggles.remoteFeatures[item.name] = item
                }
                
                completion(decodedResponse.features)
                print(decodedResponse.features)
            } catch {
                print("Ошибка парсинга JSON: \(error)")
                completion([])
            }
        }
        
        task.resume()
    }
}
