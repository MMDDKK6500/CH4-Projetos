//
//  AttatchmentNote+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 18/08/26.
//
//

public import Foundation
public import CoreData


public typealias AttatchmentNoteCoreDataPropertiesSet = NSSet

extension AttatchmentNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AttatchmentNote> {
        return NSFetchRequest<AttatchmentNote>(entityName: "AttatchmentNote")
    }

    @NSManaged public var id_attatchment: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var note: Note?

}

extension AttatchmentNote : Identifiable {

}
