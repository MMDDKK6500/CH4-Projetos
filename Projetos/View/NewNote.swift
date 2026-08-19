//
//  NewNote.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI

struct NewNote: View {
    
    @State private var titleNote: String
    @State private var descriptionNote: String = ""
    
    init(initialTitle: String = "") {
            _titleNote = State(initialValue: initialTitle)
        }
    
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
    }
}

#Preview {
    NewNote()
}
