//
//  NotificationOptions.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 21/08/26.
//

enum NotificationOptions: Int, CaseIterable {
    case never
    case daily
    case weekDay
    case weekend
    case fortnightly
    case monthly

    var toString : String {
        switch self {
        case .never:
            return "Nunca"
        case .daily:
            return "Diariamente"
        case .weekDay:
            return "Dias de Semana"
        case .weekend:
            return "Finais de Semana"
        case .fortnightly:
            return "Quinzenalmente"
        case .monthly:
            return "Mensalmente"
        }
    }
}
