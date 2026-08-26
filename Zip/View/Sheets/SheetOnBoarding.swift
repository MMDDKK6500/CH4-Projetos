//
//  SheetOnBoarding.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI

struct SheetOnBoarding: View {
    @Environment(\.dismiss) private var dismiss
    var onComplete: () -> Void = {}

    var body: some View {
        NavigationStack {
            ZStack {

                Color(uiColor: UIColor.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 50) {

                    Text("Descubra tudo que o Zip oferece")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                        .padding(.top, 50)

                    VStack(spacing: 40) {

                        TextOnBoarding(
                            text:
                                "Organize seus prazos e encontros. Visualize as datas importantes do projeto e saiba o que vem pela frente.",
                            icon: "calendar"
                        )
                        TextOnBoarding(
                            text:
                                "Não deixe nenhuma tarefa para trás. Crie lembretes para acompanhar o que precisa ser feito e quando.",
                            icon: "checklist"
                        )
                        TextOnBoarding(
                            text:
                                "Registre suas ideias e informações. Anote detalhes, referências e tudo o que for importante para o projeto.",
                            icon: "pencil.line"
                        )
                    }
                    .padding(.bottom, 70)

                    Button {
                        onComplete()
                        dismiss()
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
                    .padding(.horizontal, 10)

                }
                .padding(30)
                .navigationBarTitleDisplayMode(.inline)
                .presentationDragIndicator(.visible)

            }
        }
    }
}

#Preview {
    SheetOnBoarding()
        .sheet(isPresented: .constant(true)) {
            SheetOnBoarding()
        }
}
