//
//  SheetNewTask.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI
internal import CoreData

struct NewTask: View {
    
    @State var titleTask: String = ""
    @State var descriptionTask: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var toggleAllDay: Bool = false
    @State var colorValue: Int = 0
    
    var textLengh: Int = 128
    
    @State var selection: TaskStatus = .toDo
    
    let project: Project
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
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
                    ColorPickerView(colorValue: $colorValue)
                }
                Picker("Status da Tarefa", selection: $selection) {
                    ForEach (TaskStatus.allCases, id: \.self) { option in
                        Text(option.toString)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("", systemImage: "xmark", role: .cancel) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("", systemImage: "checkmark", role: .confirm) {
                    
                    let task = Task(context: moc)
                    
                    task.title = titleTask
                    task.text = descriptionTask
                    task.color = Int64(colorValue)
                    task.start = startDate
                    task.end = endDate
                    task.project = project
                    task.id_task = UUID()
                    task.status = Int64(selection.rawValue)
                    
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
