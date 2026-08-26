//
//  SheetNewTask.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftData
import SwiftUI

struct NewTask: View {

    @State var vm = NewTaskViewModel()

    var textLengh: Int = 128

    let project: Project

    @Environment(\.modelContext) var moc
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section(header: Text("Título da Tarefa")) {
                TextField("Título", text: $vm.titleTask)
            }

            Section(header: Text("Descrição da Tarefa")) {
                TextField(
                    "Fale brevemente sobre sua tarefa.",
                    text: $vm.descriptionTask,
                    axis: .vertical
                )
                .lineLimit(6...6)
                .onChange(
                    of: vm.descriptionTask,
                    {
                        vm.descriptionTask = String(
                            vm.descriptionTask.prefix(textLengh)
                        )
                    }
                )

            }
            Section(header: Text("Lembrete")) {
                HStack {
                    Text("Dia Inteiro")
                    Spacer()
                    Toggle(isOn: $vm.toggleAllDay) {}
                        .tint(Color.lightBlue)
                }
                HStack {
                    Text("Começa")
                    Spacer()
                    DatePicker(
                        "",
                        selection: $vm.startDate,
                        displayedComponents: vm.toggleAllDay
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
                        selection: $vm.endDate,
                        displayedComponents: vm.toggleAllDay
                            ? [.date] : [.date, .hourAndMinute]
                    )
                }

                Picker("Notificação", selection: $vm.selectionNotification) {
                    ForEach(NotificationOptions.allCases, id: \.self) {
                        option in
                        Text(option.toString)
                    }
                }

            }
            .onChange(of: [vm.endDate, vm.startDate]) {
                if vm.endDate < vm.startDate {
                    vm.endDate = vm.startDate
                }
            }

            Section(header: Text("Personalização")) {
                HStack {
                    Text("Cor da Tarefa")
                    Spacer()
                    ColorPickerView(colorValue: $vm.colorValue)
                }
                Picker("Status da Tarefa", selection: $vm.selectionStatus) {
                    ForEach(TaskStatus.allCases, id: \.self) { option in
                        Text(option.toString)
                    }
                }
            }
        }

        .alert("Error", isPresented: $vm.createError) {
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

                    vm.createTask(
                        project: project,
                        moc: moc
                    )

                    if !vm.createError {
                        dismiss()
                    }
                }
            }
        }
    }
}
