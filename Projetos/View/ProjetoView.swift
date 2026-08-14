//
//  ProjetoView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

import SwiftUI

struct ProjetoView: View {
    
    @State private var birthday = Date()
    @State private var isShowingAlert = false
    @State private var selectedDate: Date = Date()
    
    let projeto: Projeto
    
    var body: some View {
        VStack {
            CustomCalendarView(daySelect: showAlert)
                .glassEffect(in:
                        .rect(cornerRadius: 25)
                )
        }
        
        .alert("Dia selecionado", isPresented: $isShowingAlert, presenting: selectedDate) { details in
            Button("OK", role: .cancel) { }
        } message: { details in
            Text(details.formatted())
        }
        
        .navigationTitle(projeto.nome ?? "Projeto sem nome")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarTitleDisplayMode(.inlineLarge)
        
    }
}

extension ProjetoView {
    func showAlert(_ date: Date) {
        selectedDate = date
        isShowingAlert.toggle()
    }
}
