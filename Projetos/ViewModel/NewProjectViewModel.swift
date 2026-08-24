//
//  NewProjectViewModel.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 24/08/26.
//

import Foundation
import Observation
import SwiftUI

@Observable
class NewProjectViewModel {

    func handleProject(
        project: Project? = nil,
        titleProject: String,
        descriptionProject: String,
        isFavorite: Bool,
        startDate: Date,
        color: Int,
        imageData: Data?,
        endDate: Date,
        image: Image?
    ) -> Project? {
        if let projeto = project {

            projeto.name = titleProject
            projeto.descriptionText = descriptionProject
            projeto.favorite = isFavorite
            projeto.start = startDate
            projeto.color = Int64(color)
            projeto.image = image == nil ? nil : imageData
            projeto.end = endDate

            return nil

        } else {

            let novoProjeto = Project(
                descriptionText: descriptionProject,
                end: endDate,
                id_project: UUID(),
                name: titleProject,
                start: startDate
            )

            novoProjeto.color = Int64(color)
            novoProjeto.image = image == nil ? nil : imageData
            novoProjeto.favorite = isFavorite

            return novoProjeto
        }
    }

}
