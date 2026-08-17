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

enum CoreDataColor: Int {
    case red, green, blue
    
    var color: Color {
        switch self {
        case .red: return Color.blue
            case .green: return Color.green
            case .blue: return Color.blue
        }
    }
    
}
