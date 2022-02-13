//
//  CharacterDB+CoreDataProperties.swift
//  MarvelApp
//
//  Created by andrey rulev on 13.02.2022.
//
//

import Foundation
import CoreData


extension CharacterDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterDB> {
        return NSFetchRequest<CharacterDB>(entityName: "CharacterDB")
    }

    @NSManaged public var name: String?
    @NSManaged public var descr: String?
    @NSManaged public var id: Int64

}