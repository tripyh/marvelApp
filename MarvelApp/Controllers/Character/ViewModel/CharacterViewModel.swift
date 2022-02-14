//
//  CharacterViewModel.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import ReactiveCocoa
import ReactiveSwift
import CoreData

class CharacterViewModel: NSObject {
    
    // MARK: - Public properties
    
    let reload: Signal<(), Never>
    let showError: Signal<String, Never>
    var loading: Property<Bool> { return Property(_loading) }
    let insertIndexPath: Signal<IndexPath, Never>
    let deleteIndexPath: Signal<IndexPath, Never>
    let updateIndexPath: Signal<IndexPath, Never>
    
    // MARK: - Private properties
    
    private let reloadObserver: Signal<(), Never>.Observer
    private let showErrorObserver: Signal<String, Never>.Observer
    private let _loading: MutableProperty<Bool> = MutableProperty(false)
    private let insertIndexPathObserver: Signal<IndexPath, Never>.Observer
    private let deleteIndexPathObserver: Signal<IndexPath, Never>.Observer
    private let updateIndexPathObserver: Signal<IndexPath, Never>.Observer
    
    private var characters = [Character]()
    private var searchCharacters = [Character]()
    private var fetchController = DataManager.shared.fetchedResultsControllerForCharacter()
    private var isSearching = false
    
    // MARK: - Lifecycle
    
    override init() {
        (reload, reloadObserver) = Signal.pipe()
        (showError, showErrorObserver) = Signal.pipe()
        (insertIndexPath, insertIndexPathObserver) = Signal.pipe()
        (deleteIndexPath, deleteIndexPathObserver) = Signal.pipe()
        (updateIndexPath, updateIndexPathObserver) = Signal.pipe()
        characters = DataManager.shared.fetchCharacters()
        reloadObserver.send(value: ())
        super.init()
        
        fetchController.delegate = self
        
        do {
            try fetchController.performFetch()
        } catch let error {
            print("performFetch error = \(error)")
        }
    }
}

// MARK: - Public

extension CharacterViewModel {
    func loadCharacters() {
        _loading.value = characters.isEmpty
        
        CharacterManager.loadCharacters { [weak self] error in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf._loading.value = false
            
            if let errorActual = error {
                strongSelf.showErrorObserver.send(value: errorActual)
            }
        }
    }
    
    var numberOfRows: Int {
        return isSearching ? searchCharacters.count : characters.count
    }
    
    func character(at index: Int) -> Character? {
        if isSearching {
            guard 0..<searchCharacters.count ~= index else {
                return nil
            }
            
            return searchCharacters[index]
        } else {
            guard 0..<characters.count ~= index else {
                return nil
            }
            
            return characters[index]
        }
    }
    
    func searchText(_ searchText: String?) {
        guard let searchTextActual = searchText,
              !searchTextActual.isEmpty else {
                  isSearching = false
                  reloadObserver.send(value: ())
                  return
              }
        
        isSearching = true
        searchCharacters = [Character]()
        
        for character in characters {
            if character.name.lowercased().contains(searchTextActual.lowercased()) {
                searchCharacters.append(character)
            }
        }
        
        reloadObserver.send(value: ())
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension CharacterViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        if isSearching {
            return
        }
        
        switch type {
        case .insert:
            if let indexPathActual = newIndexPath {
                if let characterDB = fetchController.object(at: indexPathActual) as? CharacterDB {
                    let character = Character(characterDB: characterDB)
                    characters.insert(character, at: indexPathActual.row)
                    insertIndexPathObserver.send(value: indexPathActual)
                }
            }
        case .update:
            if let indexPathActual = indexPath {
                if let characterDB = fetchController.object(at: indexPathActual) as? CharacterDB {
                    let character = Character(characterDB: characterDB)
                    characters.remove(at: indexPathActual.row)
                    characters.insert(character, at: indexPathActual.row)
                    updateIndexPathObserver.send(value: indexPathActual)
                }
            }
        case .move:
            if let indexPathActual = indexPath {
                characters.remove(at: indexPathActual.row)
                deleteIndexPathObserver.send(value: indexPathActual)
            }
            
            if let newIndexPathActual = newIndexPath {
                if let characterDB = fetchController.object(at: newIndexPathActual) as? CharacterDB {
                    let character = Character(characterDB: characterDB)
                    characters.insert(character, at: newIndexPathActual.row)
                    insertIndexPathObserver.send(value: newIndexPathActual)
                }
            }
        case .delete:
            if let indexPathActual = indexPath {
                characters.remove(at: indexPathActual.row)
                deleteIndexPathObserver.send(value: indexPathActual)
            }
        @unknown default:
            fatalError()
        }
    }
}
