//
//  TaskStatus.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI

enum TaskStatus: Int, CaseIterable {
    case toDo
    case inProgress
    case completed
    
    var toString : String {
        switch self {
            case .toDo:
            return "To Do"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        }
    }
}
