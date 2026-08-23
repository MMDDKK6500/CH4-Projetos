//
//  User+CoreDataProperties.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 23/08/26.
//
//

public import Foundation
public import CoreData


public typealias UserCoreDataPropertiesSet = NSSet

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var onboarding: Bool

}

extension User : Identifiable {

}
