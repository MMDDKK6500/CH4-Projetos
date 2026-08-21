//
//  HomeView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

internal import CoreData
import SwiftUI

struct HomeView: View {

    @State var vm = HomeViewModel()
    
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(sortDescriptors: [])
    var projects: FetchedResults<Project>

    @State var showFutureProjects: Bool = true
    @State var showCurrentProjects: Bool = false
    @State var showOldProjects: Bool = false
    
    @State private var selectedOption: ToggleSwitch = .atuais

    @State var newProject = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    // https://stackoverflow.com/questions/60866380/swiftui-if-inside-foreach-loop
                    ForEach(projects.filter { $0.favorite == true && vm.checkProject(project: $0) == selectedOption}) {
                        project in
                        NavigationLink {
                            ProjectView(project: project)
                        } label: {
                            ProjectComponentView(project: project)
                                .background {
                                    if project.image == nil {
                                        project.getColorPalette().background
                                    } else {
                                        Image(
                                            uiImage: UIImage(data: project.image!)!
                                        )
                                        .resizable()
                                        .scaledToFill()
                                    }
                                }
                                .clipShape(
                                    .rect(cornerRadius: 26)
                                )

                        }
                        .buttonStyle(.plain)
                    }
                    LazyVGrid(
                        columns: [
                            GridItem(),
                            GridItem(),
                        ],
                        alignment: .center,
                        spacing: 10
                    ) {
                        ForEach(projects.filter { $0.favorite == false && vm.checkProject(project: $0) == selectedOption }) {
                            project in
                            NavigationLink {
                                ProjectView(project: project)
                            } label: {
                                ProjectComponentView(project: project)
                            }
                            .buttonStyle(.plain)
                            .background {
                                if project.image == nil {
                                    project.getColorPalette().background
                                } else {
                                    Image(
                                        uiImage: UIImage(data: project.image!)!
                                    )
                                    .resizable()
                                    .scaledToFill()
                                }
                            }
                            .clipShape(
                                .rect(cornerRadius: 26)
                            )

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
                    // https://stackoverflow.com/questions/57699548/using-swiftui-how-do-i-make-one-toggle-change-the-state-of-another-toggle
                    Menu {
                        Toggle("Projetos concluidos", isOn: $selectedOption.equals(.concluidos, else: .concluidos))
                        Toggle("Projetos atuais", isOn: $selectedOption.equals(.atuais, else: .atuais))
                        Toggle("Projetos futuros", isOn: $selectedOption.equals(.futuros, else: .futuros))
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }
            }

            .navigationDestination(for: Project.self) { project in
                ProjectView(project: project)
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
