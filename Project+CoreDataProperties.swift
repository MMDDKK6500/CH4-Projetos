//
//  Project+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 21/08/26.
//
//

public import Foundation
public import CoreData


public typealias ProjectCoreDataPropertiesSet = NSSet

extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var descriptionText: String?
    @NSManaged public var end: Date?
    @NSManaged public var favorite: Bool
    @NSManaged public var id_project: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var start: Date?
    @NSManaged public var color: Int64

}

extension Project : Identifiable {
    func getColorPalette() -> CoreDataColor {
        return CoreDataColor(rawValue: Int(color))!
    }
    
    func getDescriptionText() -> String {
        return descriptionText ?? ""
    }
    
    func getName() -> String {
        return name ?? ""
    }
    
    func getId() -> UUID {
        return id_project ?? UUID()
    }
    
    func getImage() -> Data {
        return image ?? Data()
    }
    
    func getStart() -> Date {
        return start ?? Date()
    }
    
    func getEnd() -> Date {
        return end ?? Date()
    }
    
    func getFavorite() -> Bool {
        return favorite
    }
}
