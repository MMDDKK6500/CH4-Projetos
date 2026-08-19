//
//  SheetNewTask.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI

struct NewTask: View {
    
    @State private var titleTask: String = ""
    @State private var descriptionTask: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var toggleAllDay: Bool = false
    private var textLengh: Int = 128
    
    @State var selection = ""
    let statusOptions = ["A fazer", "Em andamento", "Concluída"]
    
    
    var body: some View {
        Form {
            
            Section (header: Text("Título da Tarefa")){
                TextField("Título", text: $titleTask)
            }
            
            Section (header: Text("Descrição da Tarefa")){
                TextField("Fale brevemente sobre sua tarefa.", text: $descriptionTask, axis: .vertical)
                    .lineLimit(6...6)
                    .onChange(of: descriptionTask, {
                        descriptionTask = String(descriptionTask.prefix(textLengh))
                    })
                    
            }
            Section (header: Text("Lembrete")) {
                HStack {
                    Text("Dia Inteiro")
                    Spacer()
                    Toggle(isOn: $toggleAllDay) {}
                        .tint(Color.lightBlue)
                }
                HStack {
                    Text("Começa")
                    Spacer()
                    DatePicker("", selection: $startDate)
                }
                HStack {
                    Text("Termina")
                    Spacer()
                    DatePicker("", selection: $endDate)
                }
            }
            
            Section (header: Text("Personalização")) {
                HStack {
                    Text("Cor da Tarefa")
                    Spacer()
                    
                }
                Picker("Status da Tarefa", selection: $selection) {
                    ForEach (statusOptions, id: \.self) { option in
                        Text(option)
                    }
                    
                }
           
            }
            
        }
    }
}

#Preview {
    NewTask()
}
