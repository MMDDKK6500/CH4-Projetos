//
//  Note.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 24/08/26.
//
//

public import Foundation
public import SwiftData


@Model public class Note {
    var date: Date
    var id_note: UUID
    var text: String
    var title: String
    var project: Project
    public init(date: Date, id_note: UUID, text: String, title: String, project: Project) {
        self.date = date
        self.id_note = id_note
        self.text = text
        self.title = title
        self.project = project

    }
    
}
