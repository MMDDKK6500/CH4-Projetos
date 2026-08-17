//
//  Task+CoreDataProperties.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//
//

public import Foundation
public import CoreData


public typealias TaskCoreDataPropertiesSet = NSSet

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var color: Int16
    @NSManaged public var data: Date?
    @NSManaged public var id_task: UUID?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var project: Project?

}

extension Task : Identifiable {

}
