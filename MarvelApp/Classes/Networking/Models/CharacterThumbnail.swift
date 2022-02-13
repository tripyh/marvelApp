//
//  CharacterThumbnail.swift
//  MarvelApp
//
//  Created by andrey rulev on 13.02.2022.
//

import Foundation

struct CharacterThumbnail {
    let path: String
    let ext: String
    
    init(path: String,
         ext: String) {
        self.path = path
        self.ext = ext
    }
}

// MARK: - Decodable

extension CharacterThumbnail: Decodable {
    private enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let path = try container.decode(String.self, forKey: .path)
        let ext = try container.decode(String.self, forKey: .ext)
        self.init(path: path, ext: ext)
    }
}
