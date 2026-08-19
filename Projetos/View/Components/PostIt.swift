//
//  PostIt.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 18/08/26.
//

import SwiftUI
import Observation

struct PostIt: View {

    @State var viewModel: PostItViewModel
    
    let task: Task
    
    let cornerRadius: CGFloat = 26

    init(task: Task) {
        self.viewModel = PostItViewModel(task: task)
        self.task = task
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(task.title!)
                        .foregroundStyle(CoreDataColor(rawValue: Int(task.color))!.title)
                        .font(.title3.bold())
                        .lineLimit(1)
                    
                    Text(viewModel.subtitle)
                        .foregroundStyle(CoreDataColor(rawValue: Int(task.color))!.subtitle)
                        .font(.caption.bold())
                    
                    Text(task.text!)
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
                            .fill(CoreDataColor(rawValue: Int(task.color))!.tag)
                    )
            }
        }
        // calling padding() makes app brick, ok cool great I absolutely love SwiftUI
        .padding()
//        .frame(width: 200, height: 200)
        .background(
            CutCornerRectangle(cornerRadius: cornerRadius)
                .foregroundColor(CoreDataColor(rawValue: Int(task.color))!.background)
                .overlay(
                    TaskFlap(cornerRadius: cornerRadius)
                        .foregroundColor(CoreDataColor(rawValue: Int(task.color))!.tag)
                )
        )
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .aspectRatio(1, contentMode: .fill)

    }
}
