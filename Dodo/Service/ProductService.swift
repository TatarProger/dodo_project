//
//  ProductService.swift
//  Dodo
//
//  Created by Rishat Zakirov on 31.07.2024.
//

import Foundation

//DIP - dependency inversion principle (SOLID)

//protocol IProductService {
//
//    func fetchProducts(completion: @escaping((Result<[Product], Error>) -> Void))
//}
//
//class ProductsService: IProductService {
//
//    enum ServiceError: Error {
//        case server
//        case parsing
//    }
//
//    func fetchProducts(completion: @escaping((Result<[Product], Error>) -> Void)) {
//        guard let url = URL(string: "\(Constants.baseURL)/products") else {return}
//
//        let task = URLSession.shared.dataTask(with: url) {data, response, error in
//
//            if let error = error {
//                DispatchQueue.main.async {
//                    completion(Result.failure(error))
//                }
//            }
//
//            guard let data = data else { return }
//
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                completion(Result.failure(ServiceError.server))
//                return
//            }
//
//            let decoder = JSONDecoder()
//
//            do {
//                let result = try decoder.decode([Product].self, from: data)
//                DispatchQueue.main.async {
//                    completion(Result.success(result))
//                    print(result)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    print(error)
//                    completion(Result.failure(ServiceError.parsing))
//                }
//            }
//        }
//        task.resume()
//    }
//}



import Foundation

protocol IProductService {
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void)
}

final class ProductsService: IProductService {

    enum ServiceError: Error {
        case server
        case parsing
        case localFileMissing
        case badURL
    }

    private let localFilename = "products"
    private let localFileExtension = "json"

    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        // 1. сначала проверяем, доступен ли сайт
        let checkURLString = "\(Constants.baseURL)/products"
        checkURLReachable(checkURLString) { [weak self] isReachable in
            guard let self = self else { return }

            if isReachable {
                // если доступен — идём в сеть
                self.fetchFromNetwork(completion: completion)
            } else {
                // если нет — сразу локальный JSON
                self.loadLocalJSON(completion: completion)
            }
        }
    }

    // MARK: - Network

    private func fetchFromNetwork(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/products") else {
            // если сам URL не собрался — читаем локально
            loadLocalJSON(completion: completion)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // если прямая загрузка не удалась — fallback в локальный
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                self?.loadLocalJSON(completion: completion)
                return
            }

            guard let data = data else {
                self?.loadLocalJSON(completion: completion)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self?.loadLocalJSON(completion: completion)
                return
            }

            self?.decodeProducts(from: data, completion: completion, fallbackOnFail: true)
        }

        task.resume()
    }

    // MARK: - URL reachability (вариант 1)

    /// Проверяем доступность конкретного URL по HEAD
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

    private func loadLocalJSON(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: localFilename, withExtension: localFileExtension) else {
            DispatchQueue.main.async {
                completion(.failure(ServiceError.localFileMissing))
            }
            return
        }

        do {
            let data = try Data(contentsOf: url)
            decodeProducts(from: data, completion: completion, fallbackOnFail: false)
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }

    // MARK: - Decoding

    private func decodeProducts(from data: Data,
                                completion: @escaping (Result<[Product], Error>) -> Void,
                                fallbackOnFail: Bool) {
        let decoder = JSONDecoder()

        do {
            let products = try decoder.decode([Product].self, from: data)
            DispatchQueue.main.async {
                completion(.success(products))
            }
        } catch {
            print("Parsing error: \(error)")
            if fallbackOnFail {
                // если упал парсинг с сервера — попробуем локальный
                loadLocalJSON(completion: completion)
            } else {
                DispatchQueue.main.async {
                    completion(.failure(ServiceError.parsing))
                }
            }
        }
    }
}

