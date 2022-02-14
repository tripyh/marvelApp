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
}

// MARK: - Public

extension DataManager {
    
    // MARK: - Character logic
    
    func saveCharacter(_ character: Character) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterDB")
            let predicate = NSPredicate(format: "id == %d", character.id)
            fetchRequest.predicate = predicate
            
            if let currentCharacter = try managedObjectContext.fetch(fetchRequest).last as? CharacterDB,
               currentCharacter.id == character.id {
                
                // MARK: - Rewriting existing CharacterDB
                
                currentCharacter.name = character.name
                currentCharacter.descr = character.description
                
                if character.avatar == nil {
                    let thumbnailEntityDescription = NSEntityDescription.entity(forEntityName: "CharacterThumbnailDB",
                                                                                in: managedObjectContext)
                    let characterThumbnailDB = NSManagedObject(entity: thumbnailEntityDescription!,
                                                               insertInto: managedObjectContext)
                    
                    characterThumbnailDB.setValue(character.avatar?.path, forKey: "path")
                    characterThumbnailDB.setValue(character.avatar?.ext, forKey: "ext")
                    
                    currentCharacter.setValue(characterThumbnailDB, forKey: "thumbnail")
                }
            } else {
                
                // MARK: - Creating new CharacterDB
                
                let entityDescription = NSEntityDescription.entity(forEntityName: "CharacterDB",
                                                                   in: managedObjectContext)
                let managedObject = NSManagedObject(entity: entityDescription!,
                                                    insertInto: managedObjectContext)

                managedObject.setValue(character.id, forKey: "id")
                managedObject.setValue(character.name, forKey: "name")
                managedObject.setValue(character.description, forKey: "descr")
                
                let thumbnailEntityDescription = NSEntityDescription.entity(forEntityName: "CharacterThumbnailDB",
                                                                            in: managedObjectContext)
                let characterThumbnailDB = NSManagedObject(entity: thumbnailEntityDescription!,
                                                           insertInto: managedObjectContext)
                
                characterThumbnailDB.setValue(character.avatar?.path, forKey: "path")
                characterThumbnailDB.setValue(character.avatar?.ext, forKey: "ext")
                
                managedObject.setValue(characterThumbnailDB, forKey: "thumbnail")
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
    
    // MARK: - Comics logic
    
    func saveComics(_ comics: Comics, characterId: Int64) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ComicsDB")
            let predicate = NSPredicate(format: "id == %d", comics.id)
            fetchRequest.predicate = predicate
            
            if let currentComisc = try managedObjectContext.fetch(fetchRequest).last as? ComicsDB,
               currentComisc.id == comics.id {
                
                // MARK: - Rewriting existing ComicsDB
                
                currentComisc.title = comics.title
                currentComisc.descr = comics.description
                
                if comics.avatar == nil {
                    let thumbnailEntityDescription = NSEntityDescription.entity(forEntityName: "CharacterThumbnailDB",
                                                                                in: managedObjectContext)
                    let characterThumbnailDB = NSManagedObject(entity: thumbnailEntityDescription!,
                                                               insertInto: managedObjectContext)
                    
                    characterThumbnailDB.setValue(comics.avatar?.path, forKey: "path")
                    characterThumbnailDB.setValue(comics.avatar?.ext, forKey: "ext")
                    
                    currentComisc.setValue(characterThumbnailDB, forKey: "thumbnail")
                }
            } else {
                
                // MARK: - Creating new ComicsDB
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterDB")
                let predicate = NSPredicate(format: "id == %d", characterId)
                fetchRequest.predicate = predicate
                
                if let currentCharacter = try managedObjectContext.fetch(fetchRequest).last as? CharacterDB,
                   currentCharacter.id == characterId {
                    
                    guard let comicsDB = NSEntityDescription.insertNewObject(forEntityName: "ComicsDB", into: managedObjectContext) as? ComicsDB else {
                        return
                    }
                    
                    comicsDB.setValue(comics.id, forKey: "id")
                    comicsDB.setValue(comics.title, forKey: "title")
                    comicsDB.setValue(comics.description, forKey: "descr")
                    
                    let thumbnailEntityDescription = NSEntityDescription.entity(forEntityName: "CharacterThumbnailDB",
                                                                                in: managedObjectContext)
                    let characterThumbnailDB = NSManagedObject(entity: thumbnailEntityDescription!,
                                                               insertInto: managedObjectContext)
                    
                    characterThumbnailDB.setValue(comics.avatar?.path, forKey: "path")
                    characterThumbnailDB.setValue(comics.avatar?.ext, forKey: "ext")
                    comicsDB.setValue(characterThumbnailDB, forKey: "thumbnail")
                    currentCharacter.addToComics(comicsDB)
                }
            }
        } catch let error {
            print("Error in saving = \(error)")
        }
        
        saveContext()
    }
    
    func fetchComics(_ characterId: Int64) -> [Comics] {
        var comicsArr = [Comics]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ComicsDB")
        let predicate = NSPredicate(format: "character.id == %d", characterId)
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        do {
            if let currentComics = try managedObjectContext.fetch(fetchRequest) as? [ComicsDB] {
                for comicsDB in currentComics {
                    let comics = Comics(comicsDB: comicsDB)
                    comicsArr.append(comics)
                }
                
            }
        } catch let error {
            print("Error fetch = \(error)")
        }
        
        return comicsArr
    }
    
    func fetchedResultsControllerForComics(_ characterId: Int64) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ComicsDB")
        let predicate = NSPredicate(format: "character.id == %d", characterId)
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
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
