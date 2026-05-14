//
//  CatService.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 14.05.2026.
//

import Foundation

final class CatService {

    func fetchCats(limit: Int = 20) async throws -> [Cat] {

        guard let url = URL(
            string: "https://api.thecatapi.com/v1/images/search?limit=\(limit)"
        ) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)

        request.addValue(
            "live_4iLaP91HHvBCToZnyBbHcPaaKY2xlLtchJFpI9sanmUwtLMN3vRdPwWR20Zi7l0K",
            forHTTPHeaderField: "x-api-key"
        )

        let (data, _) = try await URLSession.shared.data(for: request)

        return try JSONDecoder().decode([Cat].self, from: data)
    }
}
