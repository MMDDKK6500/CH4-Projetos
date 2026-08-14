//
//  DataController.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

import Foundation
internal import CoreData
import Combine

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Projetos")
    
    init() {
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
    }
}
