//
//  NotesList.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 20/08/26.
//

import SwiftUI

struct NotesList: View {
    
    let selectedDate: Date
    let notes: [Note]
    
    var body: some View {
        List {
            ForEach(
                notes.filter {
                    $0.date == selectedDate
                }
            ) {
                note in
                NavigationLink {
//                    NoteScreen(note: note)
                } label: {
                    NoteView(note: note)
                }
            }
        }
    }
}
