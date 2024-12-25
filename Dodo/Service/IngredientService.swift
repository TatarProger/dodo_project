//
//  IngredientService.swift
//  Dodo
//
//  Created by Rishat Zakirov on 06.09.2024.
//

import Foundation

enum ServiceError: Error {
    case server
    case parsing
}

class IngredientService {
    
    func fetchIngredients(completion: @escaping((Result<[Ingredient], Error>) -> Void)) {
        guard let url = URL(string: "\(Constants.baseURL)/ingredients") else {return}
        
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
            
            guard let data = data else { return }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(Result.failure(ServiceError.server))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode([Ingredient].self, from: data)
                DispatchQueue.main.async {
                    completion(Result.success(result))
                    print(result)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(ServiceError.parsing))
                }
            }
            }
        task.resume()
        }
}

