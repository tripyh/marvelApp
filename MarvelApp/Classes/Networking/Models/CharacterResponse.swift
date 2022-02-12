//
//  CharacterResponse.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import Foundation

struct CharacterResponse {
    let data: CharacterData
    
    init(data: CharacterData) {
        self.data = data
    }
}

// MARK: Decodable

extension CharacterResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(CharacterData.self, forKey: .data)
        self.init(data: data)
    }
}
