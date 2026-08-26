//
//  CustomCalendarViewModel.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 23/08/26.
//

import Foundation
import Observation
import SwiftData
import SwiftUI

@Observable
class CustomCalendarViewModel {

    let moc: ModelContext

    let project: Project

    var selectedDate: Date = Date()

    let calendar = Calendar.current
    let daysOfWeek = ["DOM", "SEG", "TER", "QUA", "QUI", "SEX", "SAB"]

//    let notes: [Note]
//
//    let tasks: [ProjectTask]

    init(
        moc: ModelContext,
        project: Project,
//        notes: [Note],
//        tasks: [ProjectTask]
    ) {
        self.moc = moc
        self.project = project
//        self.notes = notes
//        self.tasks = tasks
    }

    func selectDate(day: Int) {
        var components = calendar.dateComponents(
            [.year, .month, .day],
            from: selectedDate
        )
        components.day = day
        guard let updatedDate = calendar.date(from: components) else {
            return
        }
        selectedDate = updatedDate
    }

    func daysInMonth(date: Date) -> Int {
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return 0
        }
        return range.count
    }

    func dayBackgroundColor(for day: Int) -> Color {
        let isCurrentMonth = calendar.isDate(
            selectedDate,
            equalTo: Date(),
            toGranularity: .month
        )
        let isSelected = calendar.isDate(
            selectedDate,
            equalTo: date(withDay: day),
            toGranularity: .day
        )

        return isCurrentMonth && isSelected ? .blue : .clear
    }

    func dayForegroundColor(for day: Int) -> Color {

        let targetDate = date(withDay: day)

        let isCurrentMonth = calendar.isDate(
            selectedDate,
            equalTo: Date(),
            toGranularity: .month
        )

        let isSelected = calendar.isDate(selectedDate, inSameDayAs: targetDate)

        let hasNote = hasNote(on: day)

        if isCurrentMonth && isSelected {
            return .white
        }
        
        if isCurrentMonth && hasNote {
            return .blue
        }

        return .primary
    }

    func date(withDay day: Int) -> Date {
        var components = calendar.dateComponents(
            [.year, .month, .day],
            from: selectedDate
        )
        components.day = day
        return calendar.date(from: components) ?? Date()
    }

    var monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    func navigateToPreviousMonth() {
        guard
            let previousMonth = calendar.date(
                byAdding: .month,
                value: -1,
                to: selectedDate
            )
        else {
            return
        }
        selectedDate = previousMonth
    }

    func navigateToNextMonth() {
        guard
            let nextMonth = calendar.date(
                byAdding: .month,
                value: 1,
                to: selectedDate
            )
        else {
            return
        }
        selectedDate = nextMonth
    }

    // Source - https://stackoverflow.com/a/76494440
    // Posted by Sweeper
    // Retrieved 2026-08-13, License - CC BY-SA 4.0

    func numberOfLeadingSpacesInMonth(of date: Date) -> Int {
        guard
            let startOfMonth = calendar.dateComponents(
                [.calendar, .year, .month],
                from: date
            ).date
        else {
            return 0
        }
        let weekdayOfStartOfMonth = calendar.component(
            .weekday,
            from: startOfMonth
        )
        // a value of 1 means Sunday, so we subtract one
        return weekdayOfStartOfMonth - 1
    }

    func updateEndDate(to newDate: Date) {
        self.project.end = newDate

        do {
            try moc.save()
        } catch {
            print("Failed to save new end date: \(error)")
        }
    }

    func hasTask(on day: Int) -> Bool {
        let targetDate = date(withDay: day)

        return project.tasks.contains(where: { (task: ProjectTask) -> Bool in

            return calendar.isDate(task.end, inSameDayAs: targetDate)
        })
    }

    func hasNote(on day: Int) -> Bool {
        let targetDate = date(withDay: day)

        return project.notes.contains(where: { (note: Note) -> Bool in

            return calendar.isDate(note.date, inSameDayAs: targetDate)
        })
    }
}
