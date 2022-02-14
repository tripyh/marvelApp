//
//  ComicsViewModel.swift
//  MarvelApp
//
//  Created by andrey rulev on 14.02.2022.
//

import ReactiveCocoa
import ReactiveSwift
import CoreData

class ComicsViewModel: NSObject {
    
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
    
    private let characterId: Int64
    private var comics = [Comics]()
    private var fetchController: NSFetchedResultsController<NSFetchRequestResult>
    
    // MARK: - Lifecycle
    
    init(characterId: Int64) {
        (reload, reloadObserver) = Signal.pipe()
        (showError, showErrorObserver) = Signal.pipe()
        (insertIndexPath, insertIndexPathObserver) = Signal.pipe()
        (deleteIndexPath, deleteIndexPathObserver) = Signal.pipe()
        (updateIndexPath, updateIndexPathObserver) = Signal.pipe()
        self.characterId = characterId
        
        comics = DataManager.shared.fetchComics(characterId)
        reloadObserver.send(value: ())
        
        fetchController = DataManager.shared.fetchedResultsControllerForComics(characterId)
        
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

extension ComicsViewModel {
    func loadComics() {
        _loading.value = comics.isEmpty
        
        CharacterManager.loadComicsCharacterId(characterId) { [weak self] error in
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
        return comics.count
    }
    
    func comics(at index: Int) -> Comics? {
        guard 0..<comics.count ~= index else {
            return nil
        }
        
        return comics[index]
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ComicsViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPathActual = newIndexPath {
                if let comicsDB = fetchController.object(at: indexPathActual) as? ComicsDB {
                    let item = Comics(comicsDB: comicsDB)
                    comics.insert(item, at: indexPathActual.row)
                    insertIndexPathObserver.send(value: indexPathActual)
                }
            }
        case .update:
            if let indexPathActual = indexPath {
                if let comicsDB = fetchController.object(at: indexPathActual) as? ComicsDB {
                    let item = Comics(comicsDB: comicsDB)
                    comics.remove(at: indexPathActual.row)
                    comics.insert(item, at: indexPathActual.row)
                    updateIndexPathObserver.send(value: indexPathActual)
                }
            }
        case .move:
            if let indexPathActual = indexPath {
                comics.remove(at: indexPathActual.row)
                deleteIndexPathObserver.send(value: indexPathActual)
            }
            
            if let newIndexPathActual = newIndexPath {
                if let comicsDB = fetchController.object(at: newIndexPathActual) as? ComicsDB {
                    let item = Comics(comicsDB: comicsDB)
                    comics.insert(item, at: newIndexPathActual.row)
                    insertIndexPathObserver.send(value: newIndexPathActual)
                }
            }
        case .delete:
            if let indexPathActual = indexPath {
                comics.remove(at: indexPathActual.row)
                deleteIndexPathObserver.send(value: indexPathActual)
            }
        @unknown default:
            fatalError()
        }
    }
}
