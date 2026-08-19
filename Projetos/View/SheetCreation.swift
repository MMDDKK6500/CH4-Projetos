//
//  SheetCreation.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI

struct SheetCreation: View {
    
    @State private var segmented = 0
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("geralBackground")
                    .ignoresSafeArea()
                
                VStack (spacing: 20){
                    
                    Spacer()
                    
                    Picker ("What is your favorite color?", selection: $segmented) {
                        Text("Tarefa").tag(0)
                        Text("Anotação").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    if segmented == 0 {
                        NewTask()
                    } else {
                        NewNote()
                    }
                }
            }
            .navigationTitle(segmented == 0 ? "Nova Tarefa" : "Nova Anotação")
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
    SheetCreation()
        .sheet(isPresented: .constant(true)) {
            SheetCreation()
        }
}

