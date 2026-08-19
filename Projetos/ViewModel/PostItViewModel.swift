//
//  PostItViewModel.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI
import Observation

@Observable
class PostItViewModel {
    
    var task: Task
    
    public private(set) var subtitle: String

    init(task: Task) {
        self.task = task
    
        if Calendar.current.isDate(task.start!, inSameDayAs: task.end!) {
            self.subtitle = task.start!.formatted(.dateTime.month(.abbreviated).day())
            + " " +
            task.start!.formatted(.dateTime.hour().minute())
            + " - " +
            task.end!.formatted(.dateTime.hour().minute())
        } else {
            self.subtitle = "a"
        }
        
    }
    
}
