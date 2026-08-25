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
    
    @State var vm = NewNoteViewModel ()
    
    let project: Project
    let selectedDate: Date
    
    var body: some View {
        Form {
            Section (header: Text("Título da Anotação")){
                TextField("Título", text: $vm.titleNote)
            }
            
            Section (header: Text("Descrição da Anotação")){
                TextField("Digite aqui o conteúdo da sua anotação.", text: $vm.descriptionNote, axis: .vertical)
                    .lineLimit(10...10)
                
            }
        }
        
        .alert("Error", isPresented: $vm.createError) {
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
                    vm.createNote(
                        project: project,
                        selectedDate: selectedDate,
                        moc: moc
                    )
                }
            }
        }
    }
}
