//
//  NewNote.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI

struct NewNote: View {
    
    @State private var titleTask: String = ""
    @State private var descriptionTask: String = ""
    
    var body: some View {
        Form {
            Section (header: Text("Título da Anotação")){
                TextField("Título", text: $titleTask)
            }
            
            Section (header: Text("Descrição da Anotação")){
                TextField("Digite aqui o conteúdo da sua anotação.", text: $descriptionTask, axis: .vertical)
                    .lineLimit(10...10)
                
            }
        }
    }
}

#Preview {
    NewNote()
}
