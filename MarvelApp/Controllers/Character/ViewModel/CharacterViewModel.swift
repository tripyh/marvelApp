//
//  CharacterViewModel.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import ReactiveCocoa
import ReactiveSwift

class CharacterViewModel {
    
    // MARK: - Public properties
    
    let reload: Signal<(), Never>
    let showError: Signal<String, Never>
    var loading: Property<Bool> { return Property(_loading) }
    
    // MARK: - Private properties
    
    private let reloadObserver: Signal<(), Never>.Observer
    private let showErrorObserver: Signal<String, Never>.Observer
    private let _loading: MutableProperty<Bool> = MutableProperty(false)
    
    private var characters = [Character]()
    
    // MARK: - Lifecycle
    
    init() {
        (reload, reloadObserver) = Signal.pipe()
        (showError, showErrorObserver) = Signal.pipe()
    }
}

// MARK: - Public

extension CharacterViewModel {
    func loadCharacters() {
        _loading.value = true
        
        CharacterManager.loadCharacters { [weak self] charactersArr, error in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf._loading.value = false
            
            if let errorActual = error {
                strongSelf.showErrorObserver.send(value: errorActual)
            } else if let charactersActual = charactersArr {
                strongSelf.characters = charactersActual
            }
            
            strongSelf.reloadObserver.send(value: ())
        }
    }
    
    var numberOfRows: Int {
        return characters.count
    }
    
    func character(at index: Int) -> Character? {
        guard 0..<characters.count ~= index else {
            return nil
        }
        
        return characters[index]
    }
}
