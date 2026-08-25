//
//  SheetNewTask.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftData
import SwiftUI

struct NewTask: View {

    @State var titleTask: String = ""
    @State var descriptionTask: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var toggleAllDay: Bool = false
    @State var colorValue: Int = 0

    var textLengh: Int = 128

    @State var selectionStatus: TaskStatus = .toDo
    @State var selectionNotification: NotificationOptions = .never

    @State var createError: Bool = false

    let project: Project

    @Environment(\.modelContext) var moc
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section(header: Text("Título da Tarefa")) {
                TextField("Título", text: $titleTask)
            }

            Section(header: Text("Descrição da Tarefa")) {
                TextField(
                    "Fale brevemente sobre sua tarefa.",
                    text: $descriptionTask,
                    axis: .vertical
                )
                .lineLimit(6...6)
                .onChange(
                    of: descriptionTask,
                    {
                        descriptionTask = String(
                            descriptionTask.prefix(textLengh)
                        )
                    }
                )

            }
            Section(header: Text("Lembrete")) {
                HStack {
                    Text("Dia Inteiro")
                    Spacer()
                    Toggle(isOn: $toggleAllDay) {}
                        .tint(Color.lightBlue)
                }
                HStack {
                    Text("Começa")
                    Spacer()
                    DatePicker(
                        "",
                        selection: $startDate,
                        displayedComponents: toggleAllDay
                            ? [.date] : [.date, .hourAndMinute]
                    )
                }
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                }

                HStack {
                    Text("Termina")
                    Spacer()
                    DatePicker(
                        "",
                        selection: $endDate,
                        displayedComponents: toggleAllDay
                            ? [.date] : [.date, .hourAndMinute]
                    )
                }

                Picker("Notificação", selection: $selectionNotification) {
                    ForEach(NotificationOptions.allCases, id: \.self) {
                        option in
                        Text(option.toString)
                    }
                }

            }

            Section(header: Text("Personalização")) {
                HStack {
                    Text("Cor da Tarefa")
                    Spacer()
                    ColorPickerView(colorValue: $colorValue)
                }
                Picker("Status da Tarefa", selection: $selectionStatus) {
                    ForEach(TaskStatus.allCases, id: \.self) { option in
                        Text(option.toString)
                    }
                }
            }
        }

        .alert("Error", isPresented: $createError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Por favor preencher todos os campos no formulário")
        }

        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("", systemImage: "xmark", role: .cancel) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("", systemImage: "checkmark", role: .confirm) {

                    if titleTask.isEmpty || descriptionTask.isEmpty {
                        createError.toggle()
                    } else {

                        let taskId = UUID()

                        let task = ProjectTask(
                            color: colorValue,
                            end: endDate,
                            id_task: UUID(),
                            isAllDay: toggleAllDay,
                            start: startDate,
                            text: descriptionTask,
                            title: titleTask,
                            status: selectionStatus
                        )

                        moc.insert(task)

                        project.tasks.append(task)

                        NotificationManager.shared.scheduleTaskNotification(
                            taskId: taskId,
                            title: titleTask,
                            endDate: endDate,
                            option: selectionNotification
                        )

                        do {

                            try moc.save()

                        } catch {
                            fatalError("Error saving context \(error)")
                        }

                        dismiss()
                    }
                }
            }
        }
    }
}
