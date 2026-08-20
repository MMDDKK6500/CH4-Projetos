//
//  NewNote.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI
internal import CoreData

struct NewNote: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @State private var titleNote: String = ""
    @State private var descriptionNote: String = ""
    
    @State private var createError: Bool = false
    
    let project: Project
    
    var body: some View {
        Form {
            Section (header: Text("Título da Anotação")){
                TextField("Título", text: $titleNote)
            }
            
            Section (header: Text("Descrição da Anotação")){
                TextField("Digite aqui o conteúdo da sua anotação.", text: $descriptionNote, axis: .vertical)
                    .lineLimit(10...10)
                
            }
        }
        
        .alert("Error", isPresented: $createError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Por favor preencher todos os campos no formulário")
        }
        
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("", systemImage: "xmark", role: .cancel) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("", systemImage: "checkmark", role: .confirm) {
                    
                    if (titleNote.isEmpty || descriptionNote.isEmpty) {
                        createError.toggle()
                    } else {
                        
                        let note = Note(context: moc)
                        
                        note.id_note = UUID()
                        note.title = titleNote
                        note.text = descriptionNote
                        note.project = project
                        
                        do {
                            try moc.save()
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
