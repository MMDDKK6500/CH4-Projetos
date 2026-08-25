//
//  NewNote.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

internal import SwiftData
import SwiftUI

struct NewNote: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @State private var titleNote: String = ""
    @State private var descriptionNote: String = ""

    @State private var createError: Bool = false

    let project: Project

    let selectedDate: Date

    var body: some View {
        Form {
            Section(header: Text("Título da Anotação")) {
                TextField("Título", text: $titleNote)
            }

            Section(header: Text("Descrição da Anotação")) {
                TextField(
                    "Digite aqui o conteúdo da sua anotação.",
                    text: $descriptionNote,
                    axis: .vertical
                )
                .lineLimit(10...10)

            }
        }

        .alert("Error", isPresented: $createError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Por favor preencher todos os campos no formulário")
        }

        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("", systemImage: "xmark", role: .cancel) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("", systemImage: "checkmark", role: .confirm) {

                    if titleNote.isEmpty || descriptionNote.isEmpty {
                        createError.toggle()
                    } else {

                        let note = Note(
                            date: selectedDate,
                            id_note: UUID(),
                            text: descriptionNote,
                            title: titleNote
                        )

                        do {
                            context.insert(note)

                            project.notes.append(note)

                            try context.save()
                        } catch {
                            fatalError("Error saving context \(error)")
                        }

                        dismiss()
                    }
                }
            }
        }
    }
}
