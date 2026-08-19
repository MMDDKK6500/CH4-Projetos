//
//  CoreDataColor.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 17/08/26.
//

import Foundation
import SwiftUI

// https://www.reddit.com/r/SwiftUI/s/us0lIR880C
// https://www.reddit.com/r/SwiftUI/comments/hjnd8k/use_a_string_from_coredata_to_set_a_color
// https://www.reddit.com/r/SwiftUI/comments/hjnd8k/comment/fwnnjhl

enum CoreDataColor: Int, CaseIterable {
    case blue, cyan, green, pink, purple, yellow

    var background: Color {
        switch self {
        case .blue: return Color.Blue.background
        case .cyan: return Color.Cyan.background
        case .green: return Color.Green.background
        case .pink: return Color.Pink.background
        case .purple: return Color.Purple.background
        case .yellow: return Color.Yellow.background
        }
    }

    var title: Color {
        switch self {
        case .blue: return Color.Blue.title
        case .cyan: return Color.Cyan.title
        case .green: return Color.Green.title
        case .pink: return Color.Pink.title
        case .purple: return Color.Purple.title
        case .yellow: return Color.Yellow.title
        }
    }

    var subtitle: Color {
        switch self {
        case .blue: return Color.Blue.subtitle
        case .cyan: return Color.Cyan.subtitle
        case .green: return Color.Green.subtitle
        case .pink: return Color.Pink.subtitle
        case .purple: return Color.Purple.subtitle
        case .yellow: return Color.Yellow.subtitle
        }
    }
    
    var tag: Color {
        switch self {
        case .blue: return Color.Blue.tag
        case .cyan: return Color.Cyan.tag
        case .green: return Color.Green.tag
        case .pink: return Color.Pink.tag
        case .purple: return Color.Purple.tag
        case .yellow: return Color.Yellow.tag
        }
    }

    var name: String {
        switch self {
        case .blue: return "Blue"
        case .cyan: return "Cyan"
        case .green: return "Green"
        case .pink: return "Pink"
        case .purple: return "Purple"
        case .yellow: return "Yellow"
        }
    }

    var nome: String {
        switch self {
        case .blue: return "Azul"
        case .cyan: return "Ciano"
        case .green: return "Verde"
        case .pink: return "Rosa"
        case .purple: return "Roxo"
        case .yellow: return "Amarelo"
        }
    }

}
