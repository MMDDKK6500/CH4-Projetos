//
//  TaskComponent.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 18/08/26.
//

import SwiftUI

struct TaskComponent: View {
    
    var color: CoreDataColor
    var radius: CGFloat = 16
    
    var body: some View {
        CutCornerRectangle(cornerRadius: radius)
            .frame(width: 100, height: 100)
            .foregroundColor(color.background)
            .overlay(
                TaskFlap(cornerRadius: radius)
                    .opacity(0.3)
            )
    }
}

#Preview {
    TaskComponent(color: .blue)
}
