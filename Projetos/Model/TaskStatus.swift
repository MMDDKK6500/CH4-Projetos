//
//  TaskStatus.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

enum TaskStatus: Int, CaseIterable {
    case toDo
    case inProgress
    case completed

    var toString: String {
        switch self {
        case .toDo:
            return "A Fazer"
        case .inProgress:
            return "Em Andamento"
        case .completed:
            return "Concluído"
        }
    }
}
