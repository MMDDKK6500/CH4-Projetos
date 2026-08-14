//
//  Projeto+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//
//

public import Foundation
public import CoreData


public typealias ProjetoCoreDataPropertiesSet = NSSet

extension Projeto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Projeto> {
        return NSFetchRequest<Projeto>(entityName: "Projeto")
    }

    @NSManaged public var cor: String?
    @NSManaged public var fim: Date?
    @NSManaged public var id_projeto: UUID?
    @NSManaged public var inicio: Date?
    @NSManaged public var nome: String?

}

extension Projeto : Identifiable {
    func getId() -> UUID? {
        return id_projeto
    }
}
