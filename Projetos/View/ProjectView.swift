//
//  ProjetoView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

import SwiftData
import SwiftUI

// TODO: Investigate why app stutters with images
// possibly because of uiimage and image and all
// because projects without image dont stutter

struct ProjectView: View {

    @Environment(\.modelContext) var moc
    @Environment(\.dismiss) var dismiss

    @State private var selectedDate: Date = Date()

    @State private var creatingNewTask: Bool = false
    @State private var editProject: Bool = false
    @State private var isNotesExpanded: Bool = false

    @State private var segmented: TaskStatus = .toDo

    @State var project: Project

    var filteredTasks: [ProjectTask] {
        project.tasks.filter { $0.status == segmented }  //Devolve array somente com o tipo da task passada no segmented
    }

    var dailyNotes: [Note] {
        project.notes.filter { note in
            return Calendar.current.isDate(selectedDate, inSameDayAs: note.date)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Cronograma")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(
                            project.image == nil
                                ? .black
                                : getBrightness(
                                    for: UIImage(data: project.getImage())!
                                )! > 128 ? .black : .white
                        )
                    CustomCalendarView(
                        daySelect: daySelect,
                        projeto: project,
                        moc: moc,
                        notes: project.notes,
                        tasks: project.tasks
                    )
                    .glassEffect(in: .rect(cornerRadius: 25.0))
                    .padding(.bottom, 10)
                    Text(
                        "Anotações do dia: \(selectedDate.formatted(date: .numeric, time: .omitted))"
                    )
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        project.image == nil
                            ? .black
                            : getBrightness(
                                for: UIImage(data: project.getImage())!
                            )! > 128 ? .black : .white
                    )

                    Spacer()

                    if dailyNotes.isEmpty {
                        
                    } else {
                        let displayedNotes =
                            isNotesExpanded
                            ? dailyNotes : Array(dailyNotes.prefix(3))

                        LazyVStack(alignment: .leading) {
                            ForEach(displayedNotes) { note in
                                NavigationLink {
                                    NoteView(note: note, moc: moc)
                                } label: {
                                    VStack {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(note.title)

                                                Text(note.text)
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                //                                                .font(.title3)
                                                .fontWeight(.medium)
                                                .foregroundStyle(.secondary)
                                        }
                                        if dailyNotes.last != note {
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
                        if isNotesExpanded && dailyNotes.count > 3 {
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
                    if dailyNotes.count > 3 && !isNotesExpanded {
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
                        .fill(
                            project.image == nil
                                ? project.getColorPalette().background
                                : Color(
                                    uiColor: UIImage(
                                        data: project.image!
                                    )!.dominantColor()!
                                )
                        )
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 26)
                )

                Text("Tarefas do projeto \(project.name)")
                    .font(.title2.bold())
                    .padding(.vertical, 18)

                Picker("", selection: $segmented) {
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
                    ForEach(filteredTasks) { task in
                        PostIt(task: task)
                    }
                }
                .animation(.spring(), value: filteredTasks)
                Spacer()
            }
            .padding()
        }

        .sheet(isPresented: $creatingNewTask) {
            SheetCreation(project: project, selectedDate: selectedDate)
        }
        .sheet(isPresented: $editProject) {
            SheetNewProject(project: project)
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
                                moc.delete(project)
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
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarTitleDisplayMode(.inlineLarge)

    }
}

extension ProjectView {
    func daySelect(_ date: Date) {
        selectedDate = date
    }
}
