//
//  ProjectViewModel.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 25/08/26.
//

import Foundation
import Observation
import SwiftData
import SwiftUI

@Observable
class ProjectViewModel {

    let moc: ModelContext

    var selectedDate: Date = Date()

    var segmented: TaskStatus = .toDo

    var project: Project

    var textColor: Color = .black
    var backgroundColor: Color = .clear

    var filteredTasks: [ProjectTask] {
        project.tasks.filter { $0.status == segmented }
    }

    var dailyNotes: [Note] {
        project.notes.filter { note in
            return Calendar.current.isDate(selectedDate, inSameDayAs: note.date)
        }
    }

    init(project: Project, moc: ModelContext) {
        self.project = project
        self.moc = moc

        self.backgroundColor = project.getColorPalette().background

        if let imageData = project.image, let uiImage = UIImage(data: imageData)
        {
            if let dominant = uiImage.dominantColor() {
                self.backgroundColor = Color(uiColor: dominant)
            }
            if let brightness = getBrightness(for: uiImage), brightness <= 128 {
                self.textColor = .white
            }
        }
    }

    func deleteProject() -> Bool {
        moc.delete(project)
        do {
            try moc.save()
            return true
        } catch {
            fatalError("Error saving context \(error)")
        }
    }

    func daySelect(_ date: Date) {
        self.selectedDate = date
    }

}
