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

    public private(set) var subtitle: String

    init(task: ProjectTask) {
        self.task = task

        if Calendar.current.isDate(task.start, inSameDayAs: task.end) {

            if task.isAllDay {
                self.subtitle = "Hoje"
                return
            }

            self.subtitle =
                task.start.formatted(.dateTime.month(.abbreviated).day())
                + " " + task.start.formatted(.dateTime.hour().minute())
                + " - " + task.end.formatted(.dateTime.hour().minute())
        } else if task.isAllDay {
            self.subtitle =
                task.start.formatted(.dateTime.month(.abbreviated).day())
                + " - "
                + task.end.formatted(.dateTime.month(.abbreviated).day())
        } else {
            self.subtitle =
                task.start.formatted(.dateTime.month(.abbreviated).day())
                + " " + task.start.formatted(.dateTime.hour().minute())
                + " - "
                + task.end.formatted(.dateTime.month(.abbreviated).day())
                + " " + task.end.formatted(.dateTime.hour().minute())
        }

    }

}
