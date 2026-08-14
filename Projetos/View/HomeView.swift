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
        VStack {
            ForEach(projects) { projeto in
                NavigationLink(projeto.nome ?? "Projeto sem nome") {
                    ProjetoView(projeto: projeto)
                }
            }
        }
        .padding()

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
        .navigationTitle("Projetos")
    }
}

#Preview {
    HomeView()
}
