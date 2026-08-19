//
//  Task+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 19/08/26.
//
//

public import Foundation
public import CoreData


public typealias TaskCoreDataPropertiesSet = NSSet

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var color: Int64
    @NSManaged public var start: Date?
    @NSManaged public var id_task: UUID?
    @NSManaged public var status: Int64
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var end: Date?
    @NSManaged public var project: Project?

}

extension Task : Identifiable {
    func getColorPalette() -> CoreDataColor {
        return CoreDataColor(rawValue: Int(color))!
    }
}
