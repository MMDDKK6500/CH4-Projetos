//
//  SheetCreation.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI

struct SheetCreation: View {

    @State private var segmented = 0

    let project: Project
    
    let selectedDate: Date

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Spacer()
                
                Picker("", selection: $segmented) {
                    Text("Tarefa").tag(0)
                    Text("Anotação").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if segmented == 0 {
                    NewTask(project: project)
                } else {
                    NewNote(project: project, selectedDate: selectedDate)
                }
            }
        }
        .background(
            Color(uiColor: UIColor.systemGroupedBackground)
        )
        .navigationTitle(segmented == 0 ? "Nova Tarefa" : "Nova Anotação")
        .navigationBarTitleDisplayMode(.inline)
        .presentationDragIndicator(.visible)
    }
}
