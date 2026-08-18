//
//  PostItColorEnum.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI

enum PostItColorEnum: String {
    case blue = "BlueNote"
    case cyan = "CyanNote"
    case yellow = "YellowNote"
    case purple = "PurpleNote"
    case green = "GreenNote"
    case pink = "PinkNote"
    
    init(imageName: String) {
            self = PostItColorEnum(rawValue: imageName) ?? .purple
        }
    
    var tagBackgroundColor: Color {
            switch self {
            case .pink: return Color.Pink.subtitle
            case .purple: return Color.Purple.subtitle
            case .blue: return Color.Blue.subtitle
            case .cyan: return Color.Cyan.subtitle
            case .yellow: return Color.Yellow.subtitle
            case .green: return Color.Green.subtitle
            }
        }
    
}
