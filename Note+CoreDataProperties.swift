//
//  Note+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 18/08/26.
//
//

public import Foundation
public import CoreData
import SwiftUI

public typealias NoteCoreDataPropertiesSet = NSSet

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var color: Int64
    @NSManaged public var date: Date?
    @NSManaged public var id_note: UUID?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var project: Project?

}

extension Note : Identifiable {
    func getColorPalette() -> CoreDataColor {
        return CoreDataColor(rawValue: Int(color))!
    }
}
