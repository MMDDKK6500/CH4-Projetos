//
//  TakFlap.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 18/08/26.
//

import Foundation
import SwiftUI

struct TaskFlap: Shape {

    //    var cornerRadius: CGFloat = 26

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start at top-left of the flap
        path.move(to: CGPoint(x: rect.maxX - rect.width / 5, y: rect.minY))

        path.addLine(
            to: CGPoint(
                x: rect.maxX - rect.width / 5,
                y: rect.minY + rect.width / 5 / 2
            )
        )

        //        path.addLine(to: CGPoint(x: rect.maxX - rect.width / 5 / 2, y: rect.minY + rect.width / 5))

        path.addCurve(
            to: CGPoint(
                x: rect.maxX - rect.width / 5 / 2,
                y: rect.minY + rect.width / 5
            ),
            control1: CGPoint(
                x: rect.maxX - rect.width / 5,
                y: rect.minY + rect.width / 5 / 2
            ),
            control2: CGPoint(
                x: rect.maxX - rect.width / 5,
                y: rect.minY + rect.width / 5
            )
        )

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.width / 5))

        //        path.addArc(
        //            tangent1End: CGPoint(
        //                x: rect.maxX - rect.width / 5,
        //                y: rect.minY + rect.width / 5
        //            ),
        //            tangent2End: CGPoint(x: rect.maxX, y: rect.minY + rect.width / 5),
        //            radius: cornerRadius
        //

        path.closeSubpath()
        return path
    }
}
