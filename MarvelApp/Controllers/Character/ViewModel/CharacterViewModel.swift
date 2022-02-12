//
//  CharacterViewModel.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import Foundation

class CharacterViewModel {
    
}

// MARK: - Public

extension CharacterViewModel {
    func loadCharacters() {
        CharacterManager.loadCharacters()
    }
}
