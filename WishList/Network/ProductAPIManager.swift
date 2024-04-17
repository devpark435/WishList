//
//  GetWishList.swift
//  WishList
//
//  Created by 박현렬 on 4/15/24.
//

import Foundation

class ProductAPIManager {
    static let shared = ProductAPIManager()
    
    private init() {}
    
    func fetchProduct(id: Int, completion: @escaping (Result<RemoteProduct, Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/products/\(id)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let product = try decoder.decode(RemoteProduct.self, from: data)
                completion(.success(product))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
