//
//  Character.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import Foundation

struct Character {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}

// MARK: Decodable

extension Character: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        self.init(id: id)
    }
}
