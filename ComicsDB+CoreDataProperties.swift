//
//  ComicsDB+CoreDataProperties.swift
//  MarvelApp
//
//  Created by andrey rulev on 14.02.2022.
//
//

import Foundation
import CoreData


extension ComicsDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ComicsDB> {
        return NSFetchRequest<ComicsDB>(entityName: "ComicsDB")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var descr: String?
    @NSManaged public var thumbnail: CharacterThumbnailDB?
    @NSManaged public var character: CharacterDB?

}
