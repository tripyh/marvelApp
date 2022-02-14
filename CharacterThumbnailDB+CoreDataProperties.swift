//
//  CharacterThumbnailDB+CoreDataProperties.swift
//  MarvelApp
//
//  Created by andrey rulev on 14.02.2022.
//
//

import Foundation
import CoreData


extension CharacterThumbnailDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterThumbnailDB> {
        return NSFetchRequest<CharacterThumbnailDB>(entityName: "CharacterThumbnailDB")
    }

    @NSManaged public var path: String?
    @NSManaged public var ext: String?
    @NSManaged public var character: CharacterDB?
    @NSManaged public var comics: ComicsDB?

}
