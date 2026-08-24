//
//  NoteViewModel.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 24/08/26.
//

import CoreData
import Foundation
import Observation
import SwiftUI

@Observable
class NoteViewModel {

    let moc: NSManagedObjectContext

    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }

    func saveNote(
        noteTitle: Binding<String>,
        noteText: Binding<String>,
        note: Note
    ) -> Bool {
        // Access the actual string values using .wrappedValue
        // that was the problem :c
        if noteTitle.wrappedValue.isEmpty || noteText.wrappedValue.isEmpty {

            if noteTitle.wrappedValue.isEmpty {
                noteTitle.wrappedValue = note.getDate().formatted()
            }

            if noteText.wrappedValue.isEmpty {
                noteText.wrappedValue = note.getDate().formatted()
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
            //            return false
        }
    }
}
