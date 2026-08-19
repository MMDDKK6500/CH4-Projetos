//
//  Favorite.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI

struct Favorite: View {
    
    @Binding var isFavorite: Bool
    
    var body: some View {
        
        Button(action: {
            withAnimation(.bouncy){
                isFavorite.toggle()
              }})
                  {
            if isFavorite {
                Image(systemName:"star.fill")
                    .font(.body.bold())
            } else {
                Image(systemName:"star")
                    .font(.body.bold())
            }
        }
    }
}
