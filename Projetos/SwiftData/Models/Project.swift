//
//  Project.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 24/08/26.
//
//

public import Foundation
public import SwiftData


@Model public class Project {
    var color: Int64 = 0
    var descriptionText: String
    var end: Date
    var favorite: Bool = false
    var id_project: UUID
    @Attribute(.externalStorage) var image: Data?
    var name: String
    var start: Date
    var tasks: [ProjectTask]
    var notes: [Note]
    public init(descriptionText: String, end: Date, id_project: UUID, name: String, start: Date, projectTasks: [ProjectTask] = [], notes: [Note] = []) {
        self.descriptionText = descriptionText
        self.end = end
        self.id_project = id_project
        self.name = name
        self.start = start
        self.tasks = projectTasks
        self.notes = notes
    }
    
    func getImage() -> Data {
        return self.image ?? Data()
    }
    
    func getColorPalette() -> CoreDataColor {
        return CoreDataColor(rawValue: Int(self.color))!
    }
}
