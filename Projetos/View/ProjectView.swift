//
//  ProjetoView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

internal import CoreData
import SwiftUI

struct ProjectView: View {

    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State private var selectedDate: Date = Date()

    @State private var creatingNewTask: Bool = false
    @State private var editProject: Bool = false
    @State private var isNotesExpanded: Bool = false

    @State private var segmented = 0

    @ObservedObject var project: Project

    @FetchRequest
    var notes: FetchedResults<Note>

    @FetchRequest
    var tasks: FetchedResults<Task>

    var filteredTasks: [Task] {
        tasks.filter { Int($0.status) == segmented }  //Devolve array somente com o tipo da task passada no segmented
    }

    var dailyNotes: [Note] {
        notes.filter { note in
            guard let noteDate = note.date else { return false }
            return Calendar.current.isDate(selectedDate, inSameDayAs: noteDate)
        }
    }

    init(project: Project) {

        self.project = project

        _tasks = FetchRequest<Task>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Task.status, ascending: true)],
            predicate: NSPredicate(format: "project == %@", project)
        )

        _notes = FetchRequest<Note>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "project == %@", project)
        )
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
                        moc: moc
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
                                                Text(note.title ?? "Sem título")

                                                Text(note.text ?? "")
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

                Text("Tarefas do projeto \(project.getName())")
                    .font(.title2.bold())
                    .padding(.vertical, 18)

                Picker("", selection: $segmented) {
                    Text("A Fazer").tag(0)
                    Text("Em Andamento").tag(1)
                    Text("Concluído").tag(2)
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

                        dismiss()

                        moc.delete(project)

                        try? moc.save()
                    }
                }
            }
        }
        .navigationTitle(project.getName())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarTitleDisplayMode(.inlineLarge)

    }
}

extension ProjectView {
    func daySelect(_ date: Date) {
        selectedDate = date
    }
}
