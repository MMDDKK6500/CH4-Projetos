//
//  Usuario+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//
//

public import Foundation
public import CoreData


public typealias UsuarioCoreDataPropertiesSet = NSSet

extension Usuario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Usuario> {
        return NSFetchRequest<Usuario>(entityName: "Usuario")
    }

    @NSManaged public var onboarding: Bool

}

extension Usuario : Identifiable {

}
