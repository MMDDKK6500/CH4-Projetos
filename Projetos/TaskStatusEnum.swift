//
//  TaskStatus.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI

enum TaskStatusEnum: String, Identifiable {
    case toDo = "A Fazer"
    case inProgress = "Em Andamento"
    case completed = "Concluída"
    
    var id: String { self.rawValue }
}
