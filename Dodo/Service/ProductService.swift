//
//  ProductService.swift
//  Dodo
//
//  Created by Rishat Zakirov on 31.07.2024.
//

import Foundation

//DIP - dependency inversion principle (SOLID)

protocol IProductService {
    
    func fetchProducts(completion: @escaping((Result<[Product], Error>) -> Void))
}

class ProductsService: IProductService {
    
    enum ServiceError: Error {
        case server
        case parsing
    }
    
    func fetchProducts(completion: @escaping((Result<[Product], Error>) -> Void)) {
        guard let url = URL(string: "\(Constants.baseURL)/products") else {return}
        
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
                let result = try decoder.decode([Product].self, from: data)
                DispatchQueue.main.async {
                    completion(Result.success(result))
                    print(result)
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    completion(Result.failure(ServiceError.parsing))
                }
            }
        }
        task.resume()
    }
}



