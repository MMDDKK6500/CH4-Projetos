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
                    .frame(width: 170, height: 170)
                    .cornerRadius(24)
                
                Text("Bem-Vindo ao Zip")
                    .font(.largeTitle.bold())
                
                Spacer()
                Text("Zip é um aplicativo de organização e gestão de projetos que reúne tudo o que você precisa em um só lugar.")
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
            .padding(18)
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
