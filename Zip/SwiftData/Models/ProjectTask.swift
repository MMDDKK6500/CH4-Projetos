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
    var color: Int64
    var end: Date
    var id_task: UUID
    var isAllDay: Bool
    var start: Date
    var status: TaskStatus
    var text: String
    var title: String

    public init(
        color: Int,
        end: Date,
        id_task: UUID,
        isAllDay: Bool,
        start: Date,
        text: String,
        title: String,
        status: TaskStatus
    ) {
        self.end = end
        self.id_task = id_task
        self.isAllDay = isAllDay
        self.start = start
        self.text = text
        self.title = title
        self.status = status
        if color > 5 {
            self.color = 5
        } else if color < 0 {
            self.color = 0
        } else {
            self.color = Int64(color)
        }
    }

    func getColorPalette() -> ColorEnum {
        return ColorEnum(rawValue: Int(self.color))!
    }

}
