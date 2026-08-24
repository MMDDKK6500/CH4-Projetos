//
//  ProjectComponentView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 18/08/26.
//

import SwiftUI

struct ProjectComponentView: View {

    @ObservedObject var project: Project

    let uiImage: UIImage?

    var brightness: Int = 0

    init(project: Project) {
        self.project = project
        if (project.image == nil) {
            uiImage = nil
        } else {
            uiImage = UIImage(data: project.image!)!
            brightness = getBrightness(for: uiImage!)!
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                VStack {
                    Text("Prazo Final")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(project.getEnd().formatted(.dateTime.day()))
                        .font(.system(size: 48))
                        .fontWeight(.semibold)
                    Text(project.getEnd().formatted(.dateTime.month().year()))
                        .font(.caption)
                        .fontWeight(.semibold)
                }

                Text(project.getName())
                    .lineLimit(2)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
        .foregroundStyle(
            uiImage == nil ? .black : Color(brightness > 128 ? .black : .white)
        )
        .padding()
        .contentShape(Rectangle())
        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 26))
    }
}
