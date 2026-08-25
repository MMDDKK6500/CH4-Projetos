//
//  HomeViewModel.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 21/08/26.
//

import Foundation
import Observation
import SwiftUI

@Observable
class HomeViewModel {

    func checkProject(project: Project) -> ToggleSwitch {
        if project.end < Date() {
            return .concluidos
        } else if project.start > Date() {
            return .futuros
        } else {
            return .atuais
        }
    }

}
