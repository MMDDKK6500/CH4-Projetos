//
//  Project+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 17/08/26.
//
//

public import Foundation
public import CoreData
import UIKit

public typealias ProjectCoreDataPropertiesSet = NSSet

extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var color: UIColor?
    @NSManaged public var end: Date?
    @NSManaged public var id_project: UUID?
    @NSManaged public var name: String?
    @NSManaged public var start: Date?

}

extension Project : Identifiable {

}
