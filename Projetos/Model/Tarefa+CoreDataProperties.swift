//
//  Tarefa+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//
//

public import Foundation
public import CoreData


public typealias TarefaCoreDataPropertiesSet = NSSet

extension Tarefa {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tarefa> {
        return NSFetchRequest<Tarefa>(entityName: "Tarefa")
    }

    @NSManaged public var cor: String?
    @NSManaged public var data: Date?
    @NSManaged public var id_tarefa: UUID?
    @NSManaged public var texto: String?
    @NSManaged public var nome: String?
    @NSManaged public var projeto: Projeto?

}

extension Tarefa : Identifiable {

}
