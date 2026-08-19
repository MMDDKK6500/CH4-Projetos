//
//  PostItViewModel.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI

struct PostItViewModel: View {
    
    var imageNote: String
    var taskName: String
    var statusDay: String
    var descriptionTask: String
    var startDate: Date
    var endDate: Date
    var isAllDay: Bool
    
    var body: some View {
        
      
    }
}

#Preview {
    PostItViewModel(imageNote: "PinkNote", taskName: "Protótipo de Alta", statusDay: "Hoje", descriptionTask: "Entregar protótipo de alta fidelidade para os mentores.", startDate: Date(), endDate: Date(), isAllDay: false)
}
