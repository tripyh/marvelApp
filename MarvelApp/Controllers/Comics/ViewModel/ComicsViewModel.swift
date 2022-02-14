//
//  ComicsViewModel.swift
//  MarvelApp
//
//  Created by andrey rulev on 14.02.2022.
//

import Foundation

class ComicsViewModel {
    
    // MARK: - Private properties
    
    private let comicsId: Int64
    
    // MARK: - Lifecycle
    
    init(comicsId: Int64) {
        self.comicsId = comicsId
        CharacterManager.loadComicsId(comicsId) { error in
            
        }
    }
}
