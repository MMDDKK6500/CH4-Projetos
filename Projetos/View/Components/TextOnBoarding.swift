//
//  TextOnBoarding.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//
import SwiftUI

struct TextOnBoarding: View {
    let text: String
    let icon: String
    
    @ScaledMetric(relativeTo: .title) var tamanhoIcon: CGFloat = 27
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
                ZStack {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.accent)
                }
                .frame(width: 60, height: 60)
            
            Text(text)
                .font(.body.weight(.regular))
                .foregroundColor(.primary)
                .lineSpacing(3)
                .multilineTextAlignment(.leading)
            
        }
    }
}

#Preview {
    TextOnBoarding(text: "Encontre atalhos publicados pela comunidade e descubra novas maneiras de agilizar suas tarefas.", icon: "person.3.fill")
}
