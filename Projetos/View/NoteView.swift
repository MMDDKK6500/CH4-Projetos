//
//  NoteScreen.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 19/08/26.
//

internal import CoreData
import SwiftUI

struct NoteView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var vm: NoteViewModel

    let note: Note
    let moc: NSManagedObjectContext

    @State var noteTitle: String
    @State var noteText: String
    @State var editError: Bool = false
    @State var confirmationShown = false

    init(note: Note, moc: NSManagedObjectContext) {
        self.note = note
        self.moc = moc

        _noteTitle = State(initialValue: note.title!)
        _noteText = State(initialValue: note.text!)
        _vm = State(initialValue: NoteViewModel(moc: moc))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            TextField("Título da anotação", text: $noteTitle)
                .font(.title.bold())

            Text(note.getDate().formatted(date: .numeric, time: .shortened))
                .font(.body)
                .foregroundStyle(Color.secondary)

            Spacer()

            TextEditor(text: $noteText)
                .ignoresSafeArea()
                .scrollContentBackground(.hidden)

            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color(.systemGroupedBackground))

        .onChange(of: [noteText, noteTitle]) {
            if !vm.saveNote(
                noteTitle: $noteTitle,
                noteText: $noteText,
                note: note
            ) {
                editError.toggle()
            }
        }

        .alert("Error", isPresented: $editError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Por favor preencher todos os campos no formulário")
        }

        .alert("Confirmação", isPresented: $confirmationShown) {
            Button("Deletar", role: .destructive) {
                if vm.deleteNote(note: note) {
                    dismiss()
                }
            }
            Button("Cancelar", role: .cancel) {

            }
        } message: {
            Text("Você tem certeza que quer deletar essa anotação?")
        }

        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {

                ShareLink(
                    item: noteText,
                    label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                )
                .tint(.blue)

                Button(
                    role: .destructive,
                    action: {
                        confirmationShown.toggle()
                    }
                ) {
                    Label("Excluir nota", systemImage: "trash")
                }
                .tint(.red)

            }
        }
    }
}
