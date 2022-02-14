//
//  Comics.swift
//  MarvelApp
//
//  Created by andrey rulev on 14.02.2022.
//

import Foundation

struct Comics {
    let id: Int64
    let title: String
    let description: String?
    let avatar: CharacterThumbnail?
    
    init(id: Int64,
         title: String,
         description: String?,
         avatar: CharacterThumbnail?) {
        self.id = id
        self.title = title
        self.description = description
        self.avatar = avatar
    }
}

// MARK: - Decodable

extension Comics: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id, title, description
        case avatar = "thumbnail"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int64.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let description = try container.decodeIfPresent(String.self, forKey: .description)
        let avatar = try container.decodeIfPresent(CharacterThumbnail.self, forKey: .avatar)
        self.init(id: id, title: title, description: description, avatar: avatar)
    }
}
