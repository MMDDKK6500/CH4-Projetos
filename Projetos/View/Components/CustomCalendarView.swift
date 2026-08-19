//
//  CustomCalendarView.swift
//
//  Source - https://stackoverflow.com/q/76493800
//  Posted by kitchen800
//  Retrieved 2026-08-13, License - CC BY-SA 4.0
//
//  Edited by João Duque Nardelli Wandermuren
//

import SwiftUI
internal import CoreData

struct CustomCalendarView: View {
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    let daySelect: (_ selectedDate: Date) -> Void;
    
    @Environment(\.managedObjectContext) var moc
    
    let projeto: Project
    
    @State private var selectedDate: Date = Date()
    @State var endDate: Date

    init(daySelect: @escaping (_ selectedDate: Date) -> Void, projeto: Project) {
        self.daySelect = daySelect
        self.projeto = projeto
        
        endDate = projeto.end!
        
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(monthYearFormatter.string(from: selectedDate))
                    .font(.headline)
                //.padding(.bottom, 10)

                // TODO: Month/Year Select

                Spacer()

                Button(action: {
                    navigateToPreviousMonth()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.primary)
                }
                .padding(.trailing, 8)

                Button(action: {
                    navigateToNextMonth()
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.primary)
                }
                .padding(.leading, 8)
            }
            .padding(.bottom, 20)

            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day.uppercased())
                        .font(.footnote)
                        .bold()
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                // Source - https://stackoverflow.com/a/76494440
                // Posted by Sweeper
                // Retrieved 2026-08-13, License - CC BY-SA 4.0

                ForEach(
                    0..<numberOfLeadingSpacesInMonth(of: selectedDate),
                    id: \.self
                ) { i in
                    Spacer().id("Spacer \(i)")
                }

                ForEach(1...daysInMonth(date: selectedDate), id: \.self) {
                    day in
                    Text("\(day)")
                        .font(.headline)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(dayBackgroundColor(for: day))
                        .foregroundColor(dayForegroundColor(for: day))

                        // https://forums.kodeco.com/t/chapter-6-circle-border/92278
                        .overlay(
                            Circle().stroke(
                                .tint,
                                lineWidth: calendar.isDate(
                                    Date(),
                                    equalTo: date(withDay: day),
                                    toGranularity: .day
                                )
                                    ? 2 : 0
                            )
                        )

                        .clipShape(Circle())
                        .onTapGesture {
                            daySelect(date(withDay: day))
                            selectDate(day: day)
                        }
                }
            }
            
            Divider()
                
            DatePicker(selection: $endDate,
                label: {
                    Text("Prazo Final")
                }
            )
            .onChange(of: endDate) {
                projeto.end = endDate
                try? moc.save()
            }
        }
        .padding()
    }

    private func selectDate(day: Int) {
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

    private func daysInMonth(date: Date) -> Int {
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return 0
        }
        return range.count
    }

    private func dayBackgroundColor(for day: Int) -> Color {
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

    private func dayForegroundColor(for day: Int) -> Color {
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
        return isCurrentMonth && isSelected ? .white : .primary
    }

    private func date(withDay day: Int) -> Date {
        var components = calendar.dateComponents(
            [.year, .month, .day],
            from: selectedDate
        )
        components.day = day
        return calendar.date(from: components) ?? Date()
    }

    private var monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    private func navigateToPreviousMonth() {
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

    private func navigateToNextMonth() {
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

    private func numberOfLeadingSpacesInMonth(of date: Date) -> Int {
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

}
