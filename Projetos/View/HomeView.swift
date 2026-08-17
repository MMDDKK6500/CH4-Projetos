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
                            let projeto = Project(context: moc)
                            
                            projeto.name = "Projeto 1"
                            projeto.id_project = UUID()
                           // projeto.color =
                            projeto.start = Date()
                            projeto.end = Calendar.current.date(
                                byAdding: .month,
                                value: 1,
                                to: Date()
                            )!
                            
                            try? moc.save()
                            
                        }
                    }
                }
//            }
            
            .navigationDestination(for: Project.self) {project in
                    ProjetoView(projeto: project)
            }
    
            .navigationTitle("Projetos")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}

#Preview {
    HomeView()
}
