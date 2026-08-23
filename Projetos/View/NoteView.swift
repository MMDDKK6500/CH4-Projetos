//
//  NoteScreen.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 19/08/26.
//

internal import CoreData
import SwiftUI

struct NoteView: View {

    @Environment(\.managedObjectContext) private var moc

    let note: Note

    @State var noteTitle: String
    @State var noteText: String
    @State var editError: Bool = false

    init(note: Note) {
        self.note = note
        _noteTitle = State(initialValue: note.title!)
        _noteText = State(initialValue: note.text!)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            TextField("Título da anotação", text: $noteTitle)
                .font(.title.bold())

            Text(note.date!.formatted(date: .numeric, time: .shortened))
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
            if noteTitle.isEmpty || noteText.isEmpty {
                noteTitle.isEmpty ? (noteTitle = note.date!.formatted()) : ()
                noteText.isEmpty ? (noteText = note.date!.formatted()) : ()

                editError.toggle()
            } else {

                //                note.id_note = UUID()
                //                note.date = Date()
                note.title = noteTitle
                note.text = noteText
                //                note.project = project

                do {
                    try moc.save()
                } catch {
                    fatalError("Error saving context \(error)")
                }
            }
        }

        .alert("Error", isPresented: $editError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Por favor preencher todos os campos no formulário")
        }

        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                //                Button(action: {}) {
                //                    Image(systemName: "square.and.arrow.up")
                //                }
                ShareLink(
                    item: noteText,
                    label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                )
                .tint(.blue)

                //                Menu {

                // How to do this?
                //                    Button(action: {}) {
                //                        Label("Pesquisar", systemImage: "magnifyingglass")
                //                    }

                //   Button (action: {}) {
                //       Label("Mudar modo de visualização", systemImage: colorScheme == .dark ? "moon.fill" : "sun.max.fill")
                //  }

                Button(role: .destructive, action: {}) {
                    Label("Excluir nota", systemImage: "trash")
                }
                .tint(.red)

                //                } label: {
                //                    Image(systemName: "ellipsis")
                //                }

            }

            // If can make rich text work uncomment
            //            ToolbarItemGroup(placement: .keyboard) {
            //                HStack(spacing: 20) {
            //                    Spacer()
            //                    HStack(spacing: 18) {
            //                        Button(action: {}) { Image(systemName: "paperclip") }
            //                        Button(action: {}) {
            //                            Image(systemName: "textformat.alt")
            //                        }
            //                        Button(action: {}) {
            //                            Image(systemName: "bold")
            //                        }
            //                        Button(action: {}) {
            //                            Image(systemName: "italic")
            //                        }
            //                    }
            //                    .font(.title3)
            //                    .foregroundStyle(
            //                        .primary
            //                    )
            //                }
            //            }
        }
    }
}
