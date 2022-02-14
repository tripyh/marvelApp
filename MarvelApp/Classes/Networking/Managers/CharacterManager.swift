//
//  CharacterManager.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import Moya

class CharacterManager {
    private static let provider = MoyaProvider<CharacterService>()
    
    class func loadCharacters(_ completionHandler: @escaping(String?) -> Void) {
        provider.request(.characters) { result in
            switch result {
            case .success(let success):
                do {
                    let characters = try JSONDecoder().decode(CharacterResponse.self, from: success.data)
                    
                    for character in characters.data.results {
                        DataManager.shared.saveCharacter(character)
                    }
                    
                    completionHandler(nil)
                } catch let error {
                    completionHandler(error.localizedDescription)
                }
            case .failure(let error):
                completionHandler(error.localizedDescription)
            }
        }
    }
    
    class func loadComicsCharacterId(_ characterId: Int64, completionHandler: @escaping(String?) -> Void) {
        provider.request(.comicsCharacterId(characterId)) { result in
            switch result {
            case .success(let success):
                do {
                    let comics = try JSONDecoder().decode(ComicsResponse.self, from: success.data)
                    
                    for item in comics.data.results {
                        DataManager.shared.saveComics(item, characterId: characterId)
                    }
                    completionHandler(nil)
                } catch let error {
                    completionHandler(error.localizedDescription)
                }
            case .failure(let error):
                completionHandler(error.localizedDescription)
            }
        }
    }
}
