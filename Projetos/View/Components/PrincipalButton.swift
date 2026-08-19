//
//  Button.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI

struct PrincipalButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
        .padding(.horizontal, 10)
    }
}

#Preview {
    PrincipalButton(action: {})
}
