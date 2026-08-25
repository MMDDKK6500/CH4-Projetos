//
//  NewNoteViewModel.swift
//  Projetos
//
//  Created by Mirella Bransford Lourenço on 25/08/26.
//

import SwiftUI
import Observation
import CoreData

@Observable
class NewNoteViewModel {
    
    var titleNote: String = ""
    var descriptionNote: String = ""
    var createError: Bool = false
    
    func createNote (
        project : Project,
        selectedDate : Date,
        moc: NSManagedObjectContext
    ) {
        
        if titleNote.isEmpty || descriptionNote.isEmpty {
            createError = true
        } else {
            let note = Note(context: moc)

               note.id_note = UUID()
               note.date = selectedDate
               note.title = titleNote
               note.text = descriptionNote
               note.project = project
            do {
                try moc.save()
            } catch {
                fatalError("Error saving context \(error)")
            }
        }
    }
}


