//
//  ProjectTask.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 24/08/26.
//
//

public import Foundation
public import SwiftData


@Model public class ProjectTask {
    var color: Int64 = 0
    var end: Date
    var id_task: UUID
    var isAllDay: Bool
    var start: Date
    var status: Int64 = 0
    var text: String
    var title: String
    var project: Project
    public init(end: Date, id_task: UUID, isAllDay: Bool, start: Date, text: String, title: String, project: Project) {
        self.end = end
        self.id_task = id_task
        self.isAllDay = isAllDay
        self.start = start
        self.text = text
        self.title = title
        self.project = project

    }
    
    func getColorPalette() -> CoreDataColor {
        return CoreDataColor(rawValue: Int(self.color))!
    }
    
}
