//
//  CharacterManager.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import Moya

class CharacterManager {
    private static let provider = MoyaProvider<CharacterService>()
    
    class func loadCharacters() {
        provider.request(.characters) { result in
            switch result {
            case .success(let success):
                do {
                    let characters = try JSONDecoder().decode(CharacterResponse.self, from: success.data)
                    print("characters = \(characters.data.results.count)")
                    
                } catch let error {
                    print("Error parsing = \(error)")
                }
                print("OK")
            case .failure(let error):
                print("error = \(error)")
            }
        }
    }
}
