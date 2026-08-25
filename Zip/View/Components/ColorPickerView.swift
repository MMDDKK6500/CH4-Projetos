//
//  ColorPickerView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 17/08/26.
//

import SwiftUI

struct ColorPickerView: View {

    @Binding var colorValue: Int

    var body: some View {
        HStack {
            Spacer()
            Menu {
                ForEach(CoreDataColor.allCases, id: \.self) { color in
                    Button(action: {
                        colorValue = color.rawValue
                    }) {
                        Label(
                            CoreDataColor(rawValue: color.rawValue)!.name,
                            systemImage: "circle.fill"
                        )
                        //https://stackoverflow.com/questions/75856718/swiftui-how-to-color-a-menu-button-icon-in-macos
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(
                            CoreDataColor(rawValue: color.rawValue)!.background
                        )
                    }
                }
            } label: {
                Circle()
                    .frame(maxWidth: 44, maxHeight: 44)
                    .foregroundStyle(
                        CoreDataColor(rawValue: colorValue)!.background
                    )
                    .glassEffect()
            }
        }
    }
}

#Preview {
    @Previewable @State var colorValue = 0

    List {
        ColorPickerView(colorValue: $colorValue)
    }
}
