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
    var projects: FetchedResults<Projeto>

    var body: some View {
        NavigationStack {
//            ScrollView {
                List {
                    ForEach(projects) { projeto in
                        NavigationLink(projeto.nome ?? "Projeto sem nome", value: projeto)
                    }
                    Section(header: Text("top 10 seções")) {
                        Text("a")
                    }
                }
//                .padding()
                    
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("", systemImage: "plus") {
                            let projeto = Projeto(context: moc)
                            
                            projeto.nome = "Projeto 1"
                            projeto.id_projeto = UUID()
                            projeto.cor = "red"
                            projeto.inicio = Date()
                            projeto.fim = Calendar.current.date(
                                byAdding: .month,
                                value: 1,
                                to: Date()
                            )!
                            
                            try? moc.save()
                            
                        }
                    }
                }
//            }
            
            .navigationDestination(for: Projeto.self) {project in
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
