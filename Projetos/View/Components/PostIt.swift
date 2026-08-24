import SwiftUI
import Observation
internal import CoreData

struct PostIt: View {

    @State var viewModel: PostItViewModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var task: Task
    
    let cornerRadius: CGFloat = 26
    
    private func updateTaskStatus(to newStatus: TaskStatus) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring()) {
                task.status = Int64(newStatus.rawValue)
                try? moc.save()
            }
        }
    }

    init(task: Task) {
        self.viewModel = PostItViewModel(task: task)
        self.task = task
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(task.title ?? "Nil")
                        .foregroundStyle(task.getColorPalette().title)
                        .font(.title3.bold())
                        .lineLimit(1)
                    
                    Text(viewModel.subtitle)
                        .foregroundStyle(task.getColorPalette().subtitle)
                        .font(.caption.bold())
                    
                    Text(task.text ?? "Nil")
                        .foregroundStyle(Color.black)
                        .font(.caption)
                        .lineLimit(4, reservesSpace: true)
                }
                Spacer()
            }
            HStack {
                Spacer()
                Text(TaskStatus(rawValue: Int(task.status))!.toString)
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
                
            Button(role: .destructive) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.spring()) {
                        moc.delete(task)
                        try? moc.save()
                    }
                }
            } label: {
                Label("Deletar Tarefa", systemImage: "trash")
            }
        
        }
    
    }
        
}
