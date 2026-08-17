//
//  SheetNewProject.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI

struct SheetNewProject: View {
    
    @State private var titleProject: String = ""
    @State private var descriptionProject: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var addPhoto: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            
            Form {
                HStack{
                    Spacer()
                    Button {
                        //Colocar a selecao de imagens assim que o usuario clicar
                    } label: {
                        Image(systemName: "photo.badge.plus")
                            .font(.title.bold())
                            .foregroundStyle(Color.lightBlue)
                            .frame(width: 200, height: 200)
                            .background (
                                RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 0)
                            )
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
                
                Section (header: Text("Título do Projeto")){
                    TextField("Título", text: $titleProject)
                }
                
                Section (header: Text("Descrição do Projeto")){
                    TextField("Digite aqui a descrição do seu projeto.", text: $descriptionProject, axis: .vertical)
                        .lineLimit(6...6)
                }
                
                Section (header: Text("Lembrete")){
                    HStack {
                        Text("Favoritar")
                        Spacer()
                        Favorite()
                    }
                    HStack {
                        Text("Começa")
                        DatePicker("", selection: $startDate)
                    }
                    HStack {
                        Text("Termina")
                        DatePicker("", selection: $endDate)
                    }
                }
                
            }
            .navigationTitle("Novo Projeto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("", systemImage: "xmark", role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("", systemImage: "checkmark", role: .confirm) { dismiss() }
                }
            }
            .presentationDragIndicator(.visible)
            
        }
    }
}

#Preview {
    SheetNewProject()
        .sheet(isPresented: .constant(true)) {
            SheetNewProject()
        }
}
