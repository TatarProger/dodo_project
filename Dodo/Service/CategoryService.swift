//
//  CategoryService.swift
//  Dodo
//
//  Created by Rishat Zakirov on 06.09.2024.
//

import Foundation

protocol ICategoryService {
    func fetchCategories(_ completion: @escaping ((Result<[Category], Error>)) -> Void)
}
class CategoryService: ICategoryService {
    
    func fetchCategories(_ completion: @escaping ((Result<[Category], Error>)) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/categories") else {return}
        
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
            
            guard let data = data else {return}
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(Result.failure(ServiceError.server))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                print("req ->",Thread.current)
                let result = try decoder.decode([Category].self, from: data)
                DispatchQueue.main.async {
                    print("ui ->",Thread.current)
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

