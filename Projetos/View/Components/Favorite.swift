//
//  Favorite.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI

struct Favorite: View {
    
    @State private var isOn: Bool = false
    
    var body: some View {
        
        Button(action: {
            withAnimation(.bouncy){
                isOn.toggle()
              }})
                  {
            if isOn {
                Image(systemName:"star.fill")
                    .font(.body.bold())
            } else {
                Image(systemName:"star")
                    .font(.body.bold())
            }
        }
    }
}

#Preview {
    Favorite()
}
