//
//  NewNoteViewModel.swift
//  Projetos
//
//  Created by Mirella Bransford Lourenço on 25/08/26.
//

import Observation
import SwiftData
import SwiftUI

@Observable
class NewNoteViewModel {

    var titleNote: String = ""
    var descriptionNote: String = ""

    func createNote(
        project: Project,
        selectedDate: Date,
        moc: ModelContext
    ) -> Bool {

        if titleNote.isEmpty || descriptionNote.isEmpty {
            return false
        } else {
            let note = Note(
                date: selectedDate,
                id_note: UUID(),
                text: descriptionNote,
                title: titleNote
            )

            moc.insert(note)
            
            project.notes.append(note)
            
            do {
                try moc.save()
                return true
            } catch {
                fatalError("Error saving context \(error)")
            }
        }
    }
}
