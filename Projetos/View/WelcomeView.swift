//
//  WelcomeView.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI

struct WelcomeView: View {
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var showOnboarding: Bool = false
    
   
    var body: some View {
        ZStack {
            Color("geralBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 45) {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(24)
                
                Text("Bem-Vindo ao Zip")
                    .font(.largeTitle.bold())
                
                Spacer()
                Text("Uma nova forma de organizar seus projetos, tarefas e ideias em um único espaço.")
                    .font(.body)
                Text("Planeje cada etapa, acompanhe o andamento das atividades e mantenha todas as informações importantes do seu projeto reunidas e organizadas no Zip.")
                    .font(.body)
                
                Spacer()
                
                Button {
                    showOnboarding.toggle()
                } label: {
                    HStack(spacing: 8) {
                        Text("Continuar")
                            .font(.body.weight(.bold))
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .background(Color.accent)
                    .cornerRadius(30)
                }
                
            }
            .padding(20)
        }
        .sheet(isPresented: $showOnboarding) {
            SheetOnBoarding {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        hasCompletedOnboarding = true
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
