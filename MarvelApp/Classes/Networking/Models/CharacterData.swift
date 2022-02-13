//
//  CharacterData.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import Foundation

struct CharacterData {
    let results: [Character]
    
    init(results: [Character]) {
        self.results = results
    }
}

// MARK: - Decodable

extension CharacterData: Decodable {
    private enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let results = try container.decode([Character].self, forKey: .results)
        self.init(results: results)
    }
}
