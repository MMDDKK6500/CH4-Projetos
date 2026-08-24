//
//  DataController.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

import Combine
internal import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Projects")

    init() {
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
    }
}
