//
//  CharacterManager.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import Moya

class CharacterManager {
    private static let provider = MoyaProvider<CharacterService>()
    
    class func loadCharacters(_ completionHandler: @escaping([Character]?, String?) -> Void) {
        provider.request(.characters) { result in
            switch result {
            case .success(let success):
                do {
                    let characters = try JSONDecoder().decode(CharacterResponse.self, from: success.data)
                    completionHandler(characters.data.results, nil)
                } catch let error {
                    completionHandler(nil, error.localizedDescription)
                }
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
}
