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

    func getPastProjects(projects: [Project]) -> [Project] {
        projects.filter { project in
            checkProject(project: project) == .concluidos
        }
    }

    func getFutureProjects(projects: [Project]) -> [Project] {
        projects.filter { project in checkProject(project: project) == .futuros
        }
    }

    func getCurrentProjects(projects: [Project]) -> [Project] {
        projects.filter { project in checkProject(project: project) == .atuais }
    }

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
