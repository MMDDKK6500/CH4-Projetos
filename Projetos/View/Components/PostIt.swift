//
//  PostIt.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI

struct PostIt: View {
    
let task: PostItViewModel
    
var body: some View {
    
        ZStack {
            Image(task.imageNote)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .overlay(
                    VStack {
                        VStack (alignment: .leading, spacing: 4){
                            
                            Text(task.taskName)
                                .font(.title3.bold())
                            
                            Text(task.statusDay)
                                .font(.headline.bold())
                            
                            
                            Text(task.descriptionTask)
                                .font(.subheadline)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(15)
                        
                        TagPostIt(imageName: "PinkNote", status: .toDo)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 20)
                    }
                        
                    
                    )
            
        }
        
    }
}

#Preview {
    PostIt(
        task: PostItViewModel(
            imageNote: "PinkNote",
            taskName: "Protótipo de Alta",
            statusDay: "Hoje",
            descriptionTask: "Entregar protótipo de alta fidelidade para os mentores.",
            startDate: Date(),
            endDate: Date(),
            isAllDay: false
        )
    )
}
