//
//  HomeView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

internal import CoreData
import SwiftUI

struct HomeView: View {

    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [])
    var projects: FetchedResults<Project>
    
    @State var showFutureProjects: Bool = true
    @State var showCurrentProjects: Bool = false
    @State var showOldProjects: Bool = false

    @State var newProject = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    // https://stackoverflow.com/questions/60866380/swiftui-if-inside-foreach-loop
                    ForEach(projects.filter { $0.favorite == true }) {project in
                        ProjectComponentView(project: project)
                    }
                    LazyVGrid(
                        columns: [
                            GridItem(),
                            GridItem(),
                        ],
                        alignment: .center,
                        spacing: 10
                    ) {
                        ForEach(projects.filter { $0.favorite == false }) {project in
                            ProjectComponentView(project: project)
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("", systemImage: "plus") {
                        newProject.toggle()
                    }
                    Menu {
                        Text("Projetos visíveis:")
                        Divider()
                        Toggle("Projetos Atuais", isOn: $showCurrentProjects)
                        Toggle("Projetos Passados", isOn: $showOldProjects)
                        Toggle("Projetos Futuros", isOn: $showFutureProjects)
                    } label: {
                        Label("", systemImage: "line.3.horizontal.decrease")
                    }
                }
            }
            .controlGroupStyle(.palette)

            .navigationDestination(for: Project.self) { project in
                ProjectView(projeto: project)
            }

            .navigationTitle("Meus Projetos")
            .toolbarTitleDisplayMode(.inlineLarge)

            .sheet(isPresented: $newProject) {
                SheetNewProject()
            }
        }
    }
}

#Preview {
    HomeView()
}
