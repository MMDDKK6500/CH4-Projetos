//
//  ProjetoView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

import SwiftUI

struct ProjectView: View {

    @State private var birthday = Date()
    @State private var isShowingAlert = false
    @State private var selectedDate: Date = Date()
    @State private var creatingNewTask: Bool = false
    
    @State private var segmented = 0
    
    var filteredTasks: [Task] {
            tasks.filter { Int($0.status) == segmented } //Devolve array somente com o tipo da task passada no segmented
        }

    let project: Project

    @FetchRequest
    var tasks: FetchedResults<Task>

    init(project: Project) {

        self.project = project

        _tasks = FetchRequest<Task>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "project == %@", project)
        )
    }

    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 40){
                CustomCalendarView(daySelect: showAlert, projeto: project)
                    .glassEffect(in: .rect(cornerRadius: 25.0))
                
                Text("Tarefas do projeto \(project.name ?? "criado")")
                    .font(.title2.bold())
                
                Picker ("", selection: $segmented) {
                    Text("A Fazer").tag(0)
                    Text("Em Andamento").tag(1)
                    Text("Concluído").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                
                LazyVGrid(
                    columns: [
                        GridItem(),
                        GridItem(),
                    ],
                    alignment: .center,
                    spacing: 10
                ) {
                    ForEach(filteredTasks) { task in
                    PostIt(task: task)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .alert(
            "Dia selecionado",
            isPresented: $isShowingAlert,
            presenting: selectedDate
        ) { details in

            Button("OK", role: .cancel) {}

        } message: { details in

            Text(details.formatted())

        }
        
        .sheet(isPresented: $creatingNewTask) {
            SheetCreation(project: project)
        }
        
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    creatingNewTask.toggle()
                }
            }
        }
        .navigationTitle(project.name ?? "Projeto sem nome")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarTitleDisplayMode(.inlineLarge)

    }
}

extension ProjectView {
    func showAlert(_ date: Date) {
        selectedDate = date
        isShowingAlert.toggle()
    }
}
