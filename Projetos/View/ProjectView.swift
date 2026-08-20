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
    
    let project: Project

    @FetchRequest
    var notes: FetchedResults<Note>

    @FetchRequest
    var tasks: FetchedResults<Task>
    
    var filteredTasks: [Task] {
            tasks.filter { Int($0.status) == segmented } //Devolve array somente com o tipo da task passada no segmented
        }


    init(project: Project) {

        self.project = project

        _tasks = FetchRequest<Task>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "project == %@", project)
        )

        _notes = FetchRequest<Note>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "project == %@", project)
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    CustomCalendarView(daySelect: showAlert, projeto: project)
                        .glassEffect(in: .rect(cornerRadius: 25.0))
                        .padding(.bottom, 20)
                    Text(
                        "Anotações do dia: \(selectedDate.formatted(date: .numeric, time: .omitted))"
                    )
                    .font(.title3)
                    .fontWeight(.semibold)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(
                            Color(
                                uiColor: UIImage(
                                    data: project.image!
                                )!.dominantColor()!
                            )
                        )
                )

                Text("Tarefas do projeto \(project.name ?? "criado")")
                    .font(.title2.bold())
                    .padding(.bottom, 10)

                Picker("", selection: $segmented) {
                    Text("A Fazer").tag(0)
                    Text("Em Andamento").tag(1)
                    Text("Concluído").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 10)

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
