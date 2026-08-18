//
//  TagPostIt.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI

struct TagPostIt: View {
    
    var imageName: String
    let status: TaskStatusEnum
        
    private var theme: PostItColorEnum {
            PostItColorEnum(imageName: imageName)
        }
    
        var body: some View {
            Text(status.rawValue)
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(theme.tagBackgroundColor)
                .clipShape(Capsule())
        }
    }

    #Preview {
        TagPostIt(imageName: "BlueNote", status: .toDo)
      
    }
