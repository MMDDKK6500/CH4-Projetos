//
//  NoteScreen.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 19/08/26.
//

import SwiftUI

struct NoteScreen: View {
    
    @State private var note: String
    @State private var title: String
    
    init(title: String = "", note: String = "") {
            _title = State(initialValue: title)
            _note = State(initialValue: note)
        }
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .topTrailing) {
                Color("geralBackground")
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 5) {
                    TextField("Título da anotação", text: $title)
                        .font(.title.bold())
                    
                    Text("A data vai aqui")
                        .font(.body)
                        .foregroundStyle(Color.secondary)
                    
                    Spacer()
                    
                    TextEditor(text: $note)
                        .ignoresSafeArea()
                        .scrollContentBackground(.hidden)
                    
                    Spacer()
                }
                .padding (.horizontal, 20)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button (action: {}) {
                        Image(systemName: "square.and.arrow.up" )
                    }
                        Menu(content: {
                            
                            Button (action: {}) {
                                Label("Pesquisar", systemImage: "magnifyingglass")
                            }
                            
                         //   Button (action: {}) {
                         //       Label("Mudar modo de visualização", systemImage: colorScheme == .dark ? "moon.fill" : "sun.max.fill")
                          //  }
                           
                            Button (role: .destructive, action: {}) {
                                Label("Excluir nota", systemImage:"trash")
                            }
                                .foregroundStyle(.red)
                            
                        }, label: {
                            Image(systemName:"ellipsis")})
                  
                }
                ToolbarItemGroup(placement: .keyboard) {
                    HStack(spacing: 20) {
                        Spacer()
                        HStack(spacing: 18) {
                            Button(action: {}) { Image(systemName: "paperclip") }
                            Button(action: {}) {
                                Image(systemName: "textformat.alt")
                                Button(action: {}) {
                                    Image(systemName: "bold")}
                                Button(action: {}) { Image(systemName: "italic")}
                            }
                            .font(.title3)
                            .foregroundColor(.black)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NoteScreen()
}
