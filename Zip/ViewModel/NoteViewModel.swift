//
//  NoteViewModel.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 24/08/26.
//

import Foundation
import Observation
import SwiftData
import SwiftUI

@Observable
class NoteViewModel {

    let moc: ModelContext

    init(moc: ModelContext) {
        self.moc = moc
    }

    func saveNote(
        noteTitle: Binding<String>,
        noteText: Binding<String>,
        note: Note
    ) -> Bool {
        if noteTitle.wrappedValue.isEmpty || noteText.wrappedValue.isEmpty {

            if noteTitle.wrappedValue.isEmpty {
                noteTitle.wrappedValue = note.date.formatted()
            }

            if noteText.wrappedValue.isEmpty {
                noteText.wrappedValue = note.date.formatted()
            }

            return false

        } else {
            note.title = noteTitle.wrappedValue
            note.text = noteText.wrappedValue

            do {
                try moc.save()
                return true
            } catch {
                fatalError("Error saving context \(error)")
                //                return false
            }
        }
    }

    func deleteNote(note: Note) -> Bool {
        moc.delete(note)
        do {
            try moc.save()
            return true
        } catch {
            fatalError("Error saving context \(error)")
        }
    }
}
