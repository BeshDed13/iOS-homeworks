//
//  NetworkService.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 15.02.2026.
//

import Foundation

enum AppConfiguration {
    case people(URL)
    case starships(URL)
    case planets(URL)
}

struct NetworkService {
    
    static func request(for configuration: AppConfiguration) {
        
        let url: URL
        
        switch configuration {
        case .people(let peopleURL):
            url = peopleURL
        case .starships(let starshipsURL):
            url = starshipsURL
        case .planets(let planetsURL):
            url = planetsURL
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
                print("Headers:", httpResponse.allHeaderFields)
            }
            
            if let data = data,
               let string = String(data: data, encoding: .utf8) {
                print("Data:", string)
            }
        }
        
        task.resume()
    }
}

