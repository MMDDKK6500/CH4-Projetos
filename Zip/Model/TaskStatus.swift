//
//  TaskStatus.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//
import SwiftUI

public enum TaskStatus: Int, CaseIterable, Codable {
    case toDo
    case inProgress
    case completed

    var toString: LocalizedStringKey {
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
