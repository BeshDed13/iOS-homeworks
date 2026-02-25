//
//  JSONModel.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 19.02.2026.
//

import Foundation

struct JSON {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

struct Planet: Decodable {
    let name: String
    let rotationPeriod: String
    let orbitalPeriod: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
    }
}
