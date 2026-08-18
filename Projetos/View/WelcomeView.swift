//
//  WelcomeView.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI

struct WelcomeView: View {
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
                
                PrincipalButton(action: {})
                
            }
            .padding(18)
        }
    }
}

#Preview {
    WelcomeView()
}
