//
//  CategoryService.swift
//  Dodo
//
//  Created by Rishat Zakirov on 06.09.2024.
//

//import Foundation
//
//protocol ICategoryService {
//    func fetchCategories(_ completion: @escaping ((Result<[Category], Error>)) -> Void)
//}
//class CategoryService:ICategoryService {
//
//    func fetchCategories(_ completion: @escaping ((Result<[Category], Error>)) -> Void) {
//        guard let url = URL(string: "\(Constants.baseURL)/categories") else {return}
//
//        let task = URLSession.shared.dataTask(with: url) {data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    completion(Result.failure(error))
//                }
//            }
//
//            guard let data = data else {return}
//
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                completion(Result.failure(ServiceError.server))
//                return
//            }
//
//            let decoder = JSONDecoder()
//
//            do {
//                print("req ->",Thread.current)
//                let result = try decoder.decode([Category].self, from: data)
//                DispatchQueue.main.async {
//                    print("ui ->",Thread.current)
//                    completion(Result.success(result))
//                    print(result)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(Result.failure(ServiceError.parsing))
//                }
//            }
//        }
//
//        task.resume()
//    }
//}

import Foundation

protocol ICategoryService {
    func fetchCategories(_ completion: @escaping ((Result<[Category], Error>)) -> Void)
}

final class CategoryService: ICategoryService {

    enum CategoryServiceError: Error {
        case server
        case parsing
        case localFileMissing
        case badURL
    }

    private let localFilename = "categories"
    private let localFileExtension = "json"

    func fetchCategories(_ completion: @escaping ((Result<[Category], Error>)) -> Void) {
        let checkURLString = "\(Constants.baseURL)/categories"

        // 1. сначала проверяем, жив ли эндпоинт
        checkURLReachable(checkURLString) { [weak self] isReachable in
            guard let self = self else { return }

            if isReachable {
                self.fetchFromNetwork(completion)
            } else {
                self.loadLocalJSON(completion)
            }
        }
    }

    // MARK: - Network

    private func fetchFromNetwork(_ completion: @escaping ((Result<[Category], Error>)) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/categories") else {
            loadLocalJSON(completion)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in

            if let error = error {
                print("Category network error: \(error.localizedDescription)")
                self?.loadLocalJSON(completion)
                return
            }

            guard let data = data else {
                self?.loadLocalJSON(completion)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self?.loadLocalJSON(completion)
                return
            }

            self?.decodeCategories(from: data, completion: completion, fallbackOnFail: true)
        }

        task.resume()
    }

    // MARK: - Reachability (вариант с HEAD)

    private func checkURLReachable(_ urlString: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 5

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let _ = error {
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false)
                return
            }

            completion((200...299).contains(httpResponse.statusCode))
        }.resume()
    }

    // MARK: - Local

    private func loadLocalJSON(_ completion: @escaping ((Result<[Category], Error>)) -> Void) {
        guard let url = Bundle.main.url(forResource: localFilename, withExtension: localFileExtension) else {
            DispatchQueue.main.async {
                completion(.failure(CategoryServiceError.localFileMissing))
            }
            return
        }

        do {
            let data = try Data(contentsOf: url)
            decodeCategories(from: data, completion: completion, fallbackOnFail: false)
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }

    // MARK: - Decode

    private func decodeCategories(from data: Data,
                                  completion: @escaping ((Result<[Category], Error>)) -> Void,
                                  fallbackOnFail: Bool) {
        let decoder = JSONDecoder()

        do {
            let result = try decoder.decode([Category].self, from: data)
            DispatchQueue.main.async {
                completion(.success(result))
            }
        } catch {
            print("Category parsing error: \(error)")
            if fallbackOnFail {
                loadLocalJSON(completion)
            } else {
                DispatchQueue.main.async {
                    completion(.failure(CategoryServiceError.parsing))
                }
            }
        }
    }
}
