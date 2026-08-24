//
//  AttatchmentNote.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 24/08/26.
//
//

public import Foundation
public import SwiftData


@Model public class AttatchmentNote {
    var id_attatchment: UUID
    @Attribute(.externalStorage) var image: Data
    var note: Note
    public init(id_attatchment: UUID, image: Data, note: Note) {
        self.id_attatchment = id_attatchment
        self.image = image
        self.note = note

    }
    
}
