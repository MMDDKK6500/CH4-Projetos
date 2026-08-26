//
//  PostItViewModel.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//
import Observation
import SwiftUI

@Observable
class PostItViewModel {

    var task: ProjectTask

    init(task: ProjectTask) {
        self.task = task
    }

    var subtitle: String {
        let calendar = Calendar.current
        
        let startComponents = calendar.dateComponents([.year, .month, .day], from: task.start)
        let endComponents = calendar.dateComponents([.year, .month, .day], from: task.end)
        
        guard let startDate = calendar.date(from: startComponents),
              let endDate = calendar.date(from: endComponents) else {
            return ""
        }
        
        let isToday = calendar.isDateInToday(startDate)
        let isSameDay = startDate == endDate

        if task.isAllDay {
            if isToday {
                return "Hoje"
                
            } else if isSameDay {
                return startDate.formatted(.dateTime.month(.abbreviated).day())
                
            } else {
                return startDate.formatted(.dateTime.month(.abbreviated).day())
                    + " - "
                    + endDate.formatted(.dateTime.month(.abbreviated).day())
            }
        } else {
            if isSameDay {
                return task.start.formatted(.dateTime.month(.abbreviated).day())
                    + " " + task.start.formatted(.dateTime.hour().minute())
                    + " - " + task.end.formatted(.dateTime.hour().minute())
            } else {
                return task.start.formatted(.dateTime.month(.abbreviated).day())
                    + " " + task.start.formatted(.dateTime.hour().minute())
                    + " - "
                    + task.end.formatted(.dateTime.month(.abbreviated).day())
                    + " " + task.end.formatted(.dateTime.hour().minute())
            }
        }
    }
}
