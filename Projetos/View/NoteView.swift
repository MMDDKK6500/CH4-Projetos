//
//  NoteScreen.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 19/08/26.
//

internal import SwiftData
import SwiftUI

struct NoteView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var vm: NoteViewModel

    let note: Note
    let moc: ModelContext

    @State var noteTitle: String
    @State var noteText: String
    @State var editError: Bool = false
    @State var confirmationShown = false

    init(note: Note, moc: ModelContext) {
        self.note = note
        self.moc = moc

        _noteTitle = State(initialValue: note.title)
        _noteText = State(initialValue: note.text)
        _vm = State(initialValue: NoteViewModel(moc: moc))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            TextField("Título da anotação", text: $noteTitle)
                .font(.title.bold())

            Text(note.date.formatted(date: .numeric, time: .shortened))
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
                // I should use throws > do try catch but its too close to deadline to update everything
                // Why not use the old old way of error checking? Objective-C papa would be proud
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

                Button(
                    role: .destructive,
                    action: {
                        confirmationShown.toggle()
                    }
                ) {
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
