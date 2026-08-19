//
//  ProjectComponentView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 18/08/26.
//

import SwiftUI

struct ProjectComponentView: View {

    let project: Project

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                VStack {
                    Text("Prazo Final")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(project.end!.formatted(.dateTime.day()))
                        .font(.system(size: 48))
                        .fontWeight(.semibold)
                    Text(project.end!.formatted(.dateTime.month().year()))
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                Text(project.name!)
                    .lineLimit(2)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
//        .padding(.horizontal, 10)
//        .padding(.vertical, 8)
        .padding()
        .glassEffect(in: .rect(cornerRadius: 26))
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(.red)
        )
    }
}
