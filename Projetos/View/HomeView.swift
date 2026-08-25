//
//  HomeView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

internal import SwiftData
import SwiftUI

struct HomeView: View {

    @State var vm = HomeViewModel()
    @Environment(\.modelContext) private var context
    @State var showStarAnimation = false

    @Query(sort: \Project.start, order: .forward)
    var projects: [Project]

    @State var showFutureProjects: Bool = true
    @State var showCurrentProjects: Bool = false
    @State var showOldProjects: Bool = false

    @State private var selectedOption: ToggleSwitch = .atuais
    @State var newProject = false

    var favoriteProjects: [Project] {
        projects.filter {
            $0.favorite == true
                && vm.checkProject(project: $0) == selectedOption
        }
    }

    var normalProjects: [Project] {
        projects.filter {
            $0.favorite == false
                && vm.checkProject(project: $0) == selectedOption
        }
    }

    var body: some View {
        Group {
            if projects.isEmpty {
                ContentUnavailableView {
                    Text("Você ainda não possui nenhum projeto")
                        .font(Font.title2.bold())
                } description: {
                    Text("Seus projetos criados aparecerão aqui")
                        .font(Font.body)
                }
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(
                            favoriteProjects
                        ) { project in
                            NavigationLink {
                                ProjectView(project: project, moc: context)
                            } label: {
                                ProjectComponentView(project: project)
                                    .background {
                                        if project.getImage() == Data() {
                                            project.getColorPalette().background
                                        } else {
                                            Image(
                                                uiImage: UIImage(
                                                    data: project.image!
                                                )!
                                            )
                                            .resizable()
                                            .scaledToFill()
                                        }
                                    }
                                    .clipShape(.rect(cornerRadius: 26))
                            }
                            .buttonStyle(.plain)
                        }

                        LazyVGrid(
                            columns: [GridItem(), GridItem()],
                            alignment: .center,
                            spacing: 10
                        ) {
                            ForEach(
                                normalProjects
                            ) { project in
                                NavigationLink {
                                    ProjectView(project: project, moc: context)
                                } label: {
                                    ProjectComponentView(project: project)
                                }
                                .buttonStyle(.plain)
                                .background {
                                    if project.image == nil {
                                        project.getColorPalette().background
                                    } else {
                                        Image(
                                            uiImage: UIImage(
                                                data: project.image!
                                            )!
                                        )
                                        .resizable()
                                        .scaledToFill()
                                    }
                                }
                                .clipShape(.rect(cornerRadius: 26))
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    newProject.toggle()
                }
                Menu {
                    Toggle(
                        "Projetos concluidos",
                        isOn: $selectedOption.equals(
                            .concluidos,
                            else: .concluidos
                        )
                    )
                    Toggle(
                        "Projetos atuais",
                        isOn: $selectedOption.equals(.atuais, else: .atuais)
                    )
                    Toggle(
                        "Projetos futuros",
                        isOn: $selectedOption.equals(.futuros, else: .futuros)
                    )
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                }
            }
        }
        .navigationDestination(for: Project.self) { project in
            ProjectView(project: project, moc: context)
        }
        .navigationTitle("Meus Projetos")
        .toolbarTitleDisplayMode(.inlineLarge)
        .sheet(isPresented: $newProject) {
            SheetNewProject()
        }
        .onChange(of: projects.count) { oldCount, newCount in
            if newCount > oldCount {
                withAnimation {
                    showStarAnimation = true
                }
            }
        }
        .overlay {
            if showStarAnimation {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    AnimationView(
                        imageName: "estrela_",
                        totalFrames: 30,
                        fps: 15.0,
                        holdFrame: 25,
                        holdDuration: 0.5,  
                        onComplete: {
                            withAnimation {
                                showStarAnimation = false
                            }
                        }
                    )
                    .frame(width: 400, height: 400)
                }
            }
        }
    }
}
