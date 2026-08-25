//
//  NewTaskViewModel.swift
//  Projetos
//
//  Created by Mirella Bransford Lourenço on 25/08/26.
//

import SwiftUI
import Observation
import CoreData

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
     
    func createTask(
           project: Project,
           moc: NSManagedObjectContext
       ) {

           if titleTask.isEmpty || descriptionTask.isEmpty {
               createError = true
               return
           }

           let taskId = UUID()

           let task = Task(context: moc)

           task.title = titleTask
           task.text = descriptionTask
           task.color = Int64(colorValue)
           task.start = startDate
           task.isAllDay = toggleAllDay
           task.end = endDate
           task.project = project
           task.id_task = taskId
           task.status = Int64(selectionStatus.rawValue)

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
   }
