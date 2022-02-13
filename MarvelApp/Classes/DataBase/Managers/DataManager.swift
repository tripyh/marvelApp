//
//  DataManager.swift
//  MarvelApp
//
//  Created by andrey rulev on 13.02.2022.
//

import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    // MARK: - Private properties
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "MarvelApp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "test.work", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Lifecycle
    
    init() {
        
    }
}

// MARK: - Public

extension DataManager {
    func saveCharacter(_ character: Character) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "CharacterDB",
                                                           in: managedObjectContext)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterDB")
        let predicate = NSPredicate(format: "id == %d", character.id)
        fetchRequest.predicate = predicate
                
        do {
            if let currentCharacter = try managedObjectContext.fetch(fetchRequest).last as? CharacterDB,
               currentCharacter.id == character.id {
                currentCharacter.name = character.name
                currentCharacter.descr = character.description
            } else {
                let managedObject = NSManagedObject(entity: entityDescription!,
                                                    insertInto: managedObjectContext)

                managedObject.setValue(character.id, forKey: "id")
                managedObject.setValue(character.name, forKey: "name")
                managedObject.setValue(character.description, forKey: "descr")
            }
        } catch let error {
            print("Error in saving = \(error)")
        }
        
        saveContext()
    }
    
    func fetchCharacters() -> [Character] {
        var charactersArr = [Character]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterDB")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            if let characters = try managedObjectContext.fetch(fetchRequest) as? [CharacterDB] {
                for characterDB in characters {
                    let character = Character(characterDB: characterDB)
                    charactersArr.append(character)
                }
            }
        } catch let error {
            print("Error fetch = \(error)")
        }
        
        return charactersArr
    }
    
    func fetchedResultsControllerForCharacter() -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterDB")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }
}

// MARK: - Private

private extension DataManager {
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
