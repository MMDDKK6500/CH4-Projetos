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

    @State private var birthday = Date()
    @State private var selectedDate: Date = Date()

    @State private var creatingNewTask: Bool = false
    @State private var editProject: Bool = false

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
            sortDescriptors: [],
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
                    CustomCalendarView(daySelect: daySelect, projeto: project)
                        .glassEffect(in: .rect(cornerRadius: 25.0))
                        .padding(.bottom, 20)
                    Text(
                        "Anotações do dia: \(selectedDate.formatted(date: .numeric, time: .omitted))"
                    )
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        project.image == nil
                            ? .black
                            : getBrightness(
                                for: UIImage(data: project.getImage())!
                            )! > 128 ? .black : .white
                    )

                    if dailyNotes.isEmpty {

                    } else {
                        LazyVStack(alignment: .leading) {
                            ForEach(dailyNotes) { note in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(note.title ?? "Sem título")
                                        Text(note.text ?? "")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }

                                if dailyNotes.last != note {
                                    Rectangle()
                                        .fill(.tertiary)
                                        .frame(height: 1)
                                }
                            }
                        }
                        .padding()
                        .background(.background)
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                    }
                }
                .padding()
                .overlay(alignment: .bottom) {
                    if dailyNotes.isEmpty {

                    } else {
                        VariableBlurView(
                            maxBlurRadius: 5,
                            direction: .blurredBottomClearTop
                        )
                        .frame(height: 100)
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
                    .padding(.bottom, 10)

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
                Spacer()
            }
            .padding()
        }

        .sheet(isPresented: $creatingNewTask) {
            SheetCreation(project: project)
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
