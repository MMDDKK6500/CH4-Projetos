//
//  ContentView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 11/08/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var birthday = Date()
    
    @State private var isShowingAlert = false
    
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack {
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            
            Image(systemName: "calendar")
              .font(.title3)
              .overlay { //MARK: Place the DatePicker in the overlay extension
                 DatePicker(
                     "",
                     selection: $birthday,
                     displayedComponents: [.date]
                 )
                  .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
              }
            
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
        .padding()
    }
}

extension ContentView {
    func showAlert(_ date: Date) {
        selectedDate = date
        isShowingAlert.toggle()
    }
}

#Preview {
    ContentView()
}
