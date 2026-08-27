//
//  CustomCalendarView.swift
//
//  Source - https://stackoverflow.com/q/76493800
//  Posted by kitchen800
//  Retrieved 2026-08-13, License - CC BY-SA 4.0
//
//  Edited by João Duque Nardelli Wandermuren
//

import SwiftData
import SwiftUI

struct CustomCalendarView: View {

    @Environment(\.modelContext) private var context

    let daySelect: (_ selectedDate: Date) -> Void

    let projeto: Project

    @State var vm: CustomCalendarViewModel

    @State var startDate: Date
    @State var endDate: Date

    init(
        daySelect: @escaping (_ selectedDate: Date) -> Void,
        projeto: Project,
        moc: ModelContext
    ) {

        self.daySelect = daySelect
        self.projeto = projeto

        _vm = State(
            initialValue: CustomCalendarViewModel(
                moc: moc,
                project: projeto
            )
        )
        _startDate = State(initialValue: projeto.start)
        _endDate = State(initialValue: projeto.end)
    }

    var body: some View {
        VStack {
            HStack {
                Text(vm.monthYearFormatter.string(from: vm.selectedDate))
                    .font(.headline)

                Spacer()

                Button(action: {
                    vm.navigateToPreviousMonth()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.primary)
                }
                .padding(.trailing, 8)

                Button(action: {
                    vm.navigateToNextMonth()
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
                ForEach(vm.daysOfWeek, id: \.self) { day in
                    Text(LocalizedStringKey(day))
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
                    0..<vm.numberOfLeadingSpacesInMonth(of: vm.selectedDate),
                    id: \.self
                ) { i in
                    Spacer().id("Spacer \(i)")
                }

                ForEach(1...vm.daysInMonth(date: vm.selectedDate), id: \.self) {
                    day in
                    Text("\(day)")
                        .font(.headline)
                        .fontWeight(.medium)
                        .frame(minWidth: 44, minHeight: 44)
                        //                        .frame(maxWidth: .infinity)
                        .background(vm.dayBackgroundColor(for: day))
                        .foregroundColor(vm.dayForegroundColor(for: day))
                        .clipShape(
                            .circle
                        )
                        .overlay(
                            Circle().stroke(
                                .blue,
                                lineWidth: Calendar.current.isDate(
                                    vm.selectedDate,
                                    equalTo: Date(),
                                    toGranularity: .month
                                )
                                    && Calendar.current.isDate(
                                        Date(),
                                        equalTo: vm.date(withDay: day),
                                        toGranularity: .day
                                    ) ? 1 : 0
                            )
                        )

                        .onTapGesture {
                            daySelect(vm.date(withDay: day))
                            vm.selectDate(day: day)
                        }
                }
            }

            Divider()

            DatePicker(
                selection: $endDate,
                label: {
                    Text("Prazo Final")
                }
            )
            .onChange(of: endDate) {
                projeto.end = endDate
                vm.updateEndDate(to: endDate)
            }
            .padding(.top, 8)
        }
        .padding()
    }

}
