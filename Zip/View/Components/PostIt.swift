import Observation
import SwiftData
import SwiftUI

struct PostIt: View {

    @State var viewModel: PostItViewModel
    @Environment(\.modelContext) var moc
    @Environment(\.dismiss) var dismiss

    @State var task: ProjectTask
    
    @State var editTask = false
    
    @State var confirmationShown = false

    let cornerRadius: CGFloat = 26

    init(task: ProjectTask) {
        self.viewModel = PostItViewModel(task: task)
        self.task = task
    }

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(task.title)
                        .foregroundStyle(task.getColorPalette().title)
                        .font(.title3.bold())
                        .lineLimit(1)

                    Text(viewModel.subtitle)
                        .foregroundStyle(task.getColorPalette().subtitle)
                        .font(.caption.bold())
                        .lineLimit(2, reservesSpace: true)

                    Text(task.text)
                        .foregroundStyle(Color.black)
                        .font(.caption)
                        .lineLimit(4, reservesSpace: true)
                }
                Spacer()
            }
            HStack {
                Spacer()
                Text(task.status.toString)
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.white)
                    .padding(8)
                    .background(
                        Capsule()
                            .fill(task.getColorPalette().tag)
                    )
            }
        }
        // calling padding() makes app brick, ok cool great I absolutely love SwiftUI
        .padding()
        //        .frame(width: 200, height: 200)
        .background(
            CutCornerRectangle(cornerRadius: cornerRadius)
                .foregroundColor(task.getColorPalette().background)
                .overlay(
                    TaskFlap()
                        .foregroundColor(task.getColorPalette().tag)
                )
        )
        .contextMenu {
            Menu("Alterar Status", systemImage: "arrow.triangle.2.circlepath") {
                Button("A Fazer") { updateTaskStatus(to: .toDo) }
                Button("Em Andamento") { updateTaskStatus(to: .inProgress) }
                Button("Concluído") { updateTaskStatus(to: .completed) }
            }
            Divider()
            
            Button("Editar tarefa", systemImage: "pencil") {
                editTask.toggle()
            }
            
            Button(role: .destructive) {
                confirmationShown.toggle()
            } label: {
                Label("Deletar Tarefa", systemImage: "trash")
            }

        }
        .sheet(isPresented: $editTask) {
            EditTask(project: task.project, task: task)
        }
        .alert("Confirmação", isPresented: $confirmationShown) {
            Button("Deletar", role: .destructive) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.spring()) {
                        moc.delete(task)
                        try? moc.save()
                    }
                }
            }
            Button("Cancelar", role: .cancel) {

            }
        } message: {
            Text("Você tem certeza que quer deletar essa tarefa?")
        }

    }

    private func updateTaskStatus(to newStatus: TaskStatus) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring()) {
                task.status = newStatus
                try? moc.save()
            }
        }
    }
    
}
