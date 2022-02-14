//
//  CharacterDB+CoreDataProperties.swift
//  MarvelApp
//
//  Created by andrey rulev on 14.02.2022.
//
//

import Foundation
import CoreData


extension CharacterDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterDB> {
        return NSFetchRequest<CharacterDB>(entityName: "CharacterDB")
    }

    @NSManaged public var descr: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var thumbnail: CharacterThumbnailDB?
    @NSManaged public var comics: NSSet?

}

// MARK: Generated accessors for comics
extension CharacterDB {

    @objc(addComicsObject:)
    @NSManaged public func addToComics(_ value: ComicsDB)

    @objc(removeComicsObject:)
    @NSManaged public func removeFromComics(_ value: ComicsDB)

    @objc(addComics:)
    @NSManaged public func addToComics(_ values: NSSet)

    @objc(removeComics:)
    @NSManaged public func removeFromComics(_ values: NSSet)

}
