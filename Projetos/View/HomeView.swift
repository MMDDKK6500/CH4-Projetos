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
    
    @State var newProject = false

    var body: some View {
        NavigationStack {
//            ScrollView {
                List {
                    ForEach(projects) { project in
                        NavigationLink(project.name ?? "Projeto sem nome", value: project)
                    }
                    Section(header: Text("top 10 seções")) {
                        Text("a")
                    }
                }
//                .padding()
                    
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("", systemImage: "plus") {
                            newProject.toggle()
                        }
                    }
                }
//            }
            
            .navigationDestination(for: Project.self) {project in
                    ProjectView(projeto: project)
            }
    
            .navigationTitle("Projetos")
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
