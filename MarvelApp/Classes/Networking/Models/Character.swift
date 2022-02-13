//
//  Character.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import Foundation

struct Character {
    let id: Int
    let name: String
    let description: String?
    let avatar: CharacterThumbnail?
    
    init(id: Int,
         name: String,
         description: String?,
         avatar: CharacterThumbnail?) {
        self.id = id
        self.name = name
        self.description = description
        self.avatar = avatar
    }
}

// MARK: - Decodable

extension Character: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id, name, description
        case avatar = "thumbnail"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decodeIfPresent(String.self, forKey: .description)
        let avatar = try container.decodeIfPresent(CharacterThumbnail.self, forKey: .avatar)
        self.init(id: id, name: name, description: description, avatar: avatar)
    }
}
