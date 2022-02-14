//
//  CharacterService.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import Moya

enum CharacterService: NetworkTarget {
    case characters
    case comicsCharacterId(_ characterId: Int64)
    
    var path: String {
        switch self {
        case .characters:
            return "v1/public/characters"
        case .comicsCharacterId(let characterId):
            return "v1/public/characters/\(characterId)/comics"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var task: Task {
        let params = ["apikey": "10a4b0ca05af3db0a4982aa999decb5f",
                      "ts": "theprint",
                      "hash": "c4b9c9d425d4e07ce7281162dd1f0fe4"]
        return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    }
}
