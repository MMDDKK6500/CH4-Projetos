//
//  Attatchment+CoreDataProperties.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//
//

public import Foundation
public import CoreData


public typealias AttatchmentCoreDataPropertiesSet = NSSet

extension Attatchment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attatchment> {
        return NSFetchRequest<Attatchment>(entityName: "Attatchment")
    }


}

extension Attatchment : Identifiable {

}
