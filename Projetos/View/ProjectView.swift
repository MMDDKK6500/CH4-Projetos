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
            VStack {
                CustomCalendarView(daySelect: showAlert, projeto: project)
                    .glassEffect(in: .rect(cornerRadius: 25.0))
                
                LazyVGrid(
                    columns: [
                        GridItem(),
                        GridItem(),
                    ],
                    alignment: .center,
                    spacing: 10
                ) {
                    ForEach(tasks) { task in
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
