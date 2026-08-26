//
//  NewTaskViewModel.swift
//  Projetos
//
//  Created by Mirella Bransford Lourenço on 25/08/26.
//

import Observation
import SwiftData
import SwiftUI

@Observable
class NewTaskViewModel {

    var titleTask: String = ""
    var descriptionTask: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    var toggleAllDay: Bool = false
    var colorValue: Int = 0

    var selectionStatus: TaskStatus = .toDo
    var selectionNotification: NotificationOptions = .never

    var createError: Bool = false
    
    let task: ProjectTask?
    
    init(task: ProjectTask?) {
        self.task = task
        if task != nil {
               
            self.titleTask = task!.title
            self.descriptionTask = task!.text
            self.startDate = task!.start
            self.endDate = task!.end
            self.toggleAllDay = task!.isAllDay
            self.colorValue = Int(task!.color)
            self.selectionStatus = task!.status
        }
    }

    func createTask(
        project: Project,
        moc: ModelContext
    ) {

        if titleTask.isEmpty || descriptionTask.isEmpty {
            createError = true
            return
        }

        let taskId = UUID()

        let task = ProjectTask(
            color: colorValue,
            end: endDate,
            id_task: taskId,
            isAllDay: toggleAllDay,
            start: startDate,
            text: descriptionTask,
            title: titleTask,
            status: selectionStatus,
            project: project
        )
        
        moc.insert(task)
        
        project.tasks.append(task)

        do {
            try moc.save()

            NotificationManager.shared.scheduleTaskNotification(
                taskId: taskId,
                title: titleTask,
                endDate: endDate,
                option: selectionNotification
            )

        } catch {
            fatalError("Error saving context \(error)")
        }
    }
    
    func editTask(
        moc: ModelContext
    ) {
        
        if titleTask.isEmpty || descriptionTask.isEmpty {
            createError = true
            return
        }
        
        task?.color = Int64(colorValue)
        task?.end = endDate
        task?.start = startDate
        task?.isAllDay = toggleAllDay
        task?.text = descriptionTask
        task?.title = titleTask
        task?.status = selectionStatus
        
        do {
            try moc.save()
        } catch {
            fatalError("Error saving context \(error)")
        }
    }
}
