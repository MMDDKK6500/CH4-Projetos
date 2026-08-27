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
                ForEach(ColorEnum.allCases, id: \.self) { color in
                    Button(action: {
                        colorValue = color.rawValue
                    }) {
                        Label(
                            ColorEnum(rawValue: color.rawValue)!.name,
                            systemImage: "circle.fill"
                        )
                        //https://stackoverflow.com/questions/75856718/swiftui-how-to-color-a-menu-button-icon-in-macos
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(
                            ColorEnum(rawValue: color.rawValue)!.background
                        )
                    }
                }
            } label: {
                Circle()
                    .frame(maxWidth: 44, maxHeight: 44)
                    .foregroundStyle(
                        ColorEnum(rawValue: colorValue)!.background
                    )
                    .modifier { content in
                        if #available(iOS 26, *) {
                            content.glassEffect()
                        } else {
                            content.background(.regularMaterial)
                        }
                    }
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
