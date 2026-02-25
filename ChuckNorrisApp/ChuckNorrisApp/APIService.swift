//
//  APIService.swift
//  ChuckNorrisApp
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation

struct APIQuote: Codable {
    let id: String
    let value: String
    let categories: [String]
}

class APIService {
    
    static let shared = APIService()
    
    func fetchQuote(completion: @escaping (Result<APIQuote, Error>) -> Void) {
        let url = URL(string: "https://api.chucknorris.io/jokes/random")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let quote = try JSONDecoder().decode(APIQuote.self, from: data)
                completion(.success(quote))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
