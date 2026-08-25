//
//  ProjetoView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

import SwiftData
import SwiftUI

struct ProjectView: View {

    @Environment(\.modelContext) var moc
    @Environment(\.dismiss) var dismiss

    @State var vm: ProjectViewModel

    @State var creatingNewTask: Bool = false
    @State var editProject: Bool = false
    @State var isNotesExpanded: Bool = false

    init(project: Project) {
        _vm = State(initialValue: ProjectViewModel(project: project))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Cronograma")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(vm.textColor)
                    CustomCalendarView(
                        daySelect: vm.daySelect,
                        projeto: vm.project,
                        moc: moc,
                        notes: vm.project.notes,
                        tasks: vm.project.tasks
                    )
                    .glassEffect(in: .rect(cornerRadius: 25.0))
                    .padding(.bottom, 10)
                    Text(
                        "Anotações do dia: \(vm.selectedDate.formatted(date: .numeric, time: .omitted))"
                    )
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(vm.textColor)

                    Spacer()

                    if vm.dailyNotes.isEmpty {

                    } else {
                        let displayedNotes =
                            isNotesExpanded
                            ? vm.dailyNotes : Array(vm.dailyNotes.prefix(3))

                        LazyVStack(alignment: .leading) {
                            ForEach(displayedNotes) { note in
                                NavigationLink {
                                    NoteView(note: note, moc: moc)
                                } label: {
                                    VStack {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(note.title)
                                                    .lineLimit(1)

                                                Text(note.text)
                                                    .lineLimit(3)
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                //                                                .font(.title3)
                                                .fontWeight(.medium)
                                                .foregroundStyle(.secondary)
                                        }
                                        if vm.dailyNotes.last != note {
                                            Rectangle()
                                                .fill(.tertiary)
                                                .frame(height: 1)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                        .background(
                            .background.opacity(0.5)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                        if isNotesExpanded && vm.dailyNotes.count > 3 {
                            Button {
                                withAnimation(.spring()) {
                                    // Collapse the list back to 3 items
                                    isNotesExpanded = false
                                }
                            } label: {
                                Text("Mostrar menos")
                                    .font(.footnote.bold())
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Color(UIColor.systemBackground),
                                        in: Capsule()
                                    )
                                    .shadow(
                                        color: .black.opacity(0.15),
                                        radius: 3,
                                        y: 1
                                    )
                            }
                            // This frame modifier naturally centers the button in the VStack
                            .frame(maxWidth: .infinity)
                            .padding(.top, 8)
                        }
                    }
                }
                .padding()
                .overlay(alignment: .bottom) {
                    // Only show the blur and button if there are > 3 notes and it's collapsed
                    if vm.dailyNotes.count > 3 && !isNotesExpanded {
                        ZStack(alignment: .bottom) {
                            VariableBlurView(
                                maxBlurRadius: 5,
                                direction: .blurredBottomClearTop
                            )
                            .frame(height: 100)
                            .allowsHitTesting(false)  // Ensures the blur doesn't block touches

                            // The expand button
                            Button {
                                withAnimation(.spring()) {
                                    isNotesExpanded = true
                                }
                            } label: {
                                Text("Ver todas")
                                    .font(.footnote.bold())
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Color(UIColor.systemBackground),
                                        in: Capsule()
                                    )
                                    .shadow(
                                        color: .black.opacity(0.15),
                                        radius: 5,
                                        y: 2
                                    )
                            }
                            .padding(.bottom, 15)
                        }
                    }
                }
                .background(
                    Rectangle()
                        .fill(vm.backgroundColor)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 26)
                )

                Text("Tarefas do projeto \(vm.project.name)")
                    .font(.title2.bold())
                    .padding(.vertical, 18)

                Picker("", selection: $vm.segmented) {
                    Text("A Fazer").tag(TaskStatus.toDo)
                    Text("Em Andamento").tag(TaskStatus.inProgress)
                    Text("Concluído").tag(TaskStatus.completed)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 10)

                LazyVGrid(
                    columns: [
                        GridItem(),
                        GridItem(),
                    ],
                    alignment: .center,
                    spacing: 10
                ) {
                    ForEach(vm.filteredTasks) { task in
                        PostIt(task: task)
                    }
                }
                .animation(.spring(), value: vm.filteredTasks)
                Spacer()
            }
            .padding()
        }

        .sheet(isPresented: $creatingNewTask) {
            SheetCreation(project: vm.project, selectedDate: vm.selectedDate)
        }
        .sheet(isPresented: $editProject) {
            SheetNewProject(project: vm.project)
        }

        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    creatingNewTask.toggle()
                }
                Menu("", systemImage: "ellipsis") {
                    Button("Editar projeto", systemImage: "pencil") {

                        editProject.toggle()

                    }
                    Button(
                        "Deletar projeto",
                        systemImage: "trash",
                        role: .destructive
                    ) {
                        do {
                            moc.delete(vm.project)
                            try moc.save()
                            dismiss()
                        } catch {
                            print("Failed to delete project: \(error)")
                            // If it fails, the view won't dismiss, and you'll see the error in Xcode
                        }
                    }
                }
            }
        }
        .navigationTitle(vm.project.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarTitleDisplayMode(.inlineLarge)

    }
}
