//
//  TextView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 18/08/26.
//

import SwiftUI

struct CutCornerRectangle: Shape {

    var cornerRadius: CGFloat = 26

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // top-left
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))

        // right top
        path.addLine(to: CGPoint(x: rect.maxX - rect.width / 5, y: rect.minY))

        // right mid
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.width / 5))

        // right bottom
        path.addArc(
            center: CGPoint(
                x: rect.maxX - cornerRadius,
                y: rect.maxY - cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )

        // bottom
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))

        path.addArc(
            center: CGPoint(
                x: rect.minX + cornerRadius,
                y: rect.maxY - cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))

        path.addArc(
            center: CGPoint(
                x: rect.minX + cornerRadius,
                y: rect.minY + cornerRadius
            ),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )

        path.closeSubpath()
        return path
    }
}
