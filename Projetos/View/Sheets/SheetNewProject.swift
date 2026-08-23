//
//  SheetNewProject.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 17/08/26.
//

import SwiftUI
internal import CoreData
import PhotosUI

struct SheetNewProject: View {
    
    @State private var titleProject: String = ""
    @State private var descriptionProject: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isFavorite: Bool = false
    
    @State private var color: Int = 0
    
    @State var image: Image?
    
    @State var imageData: Data?
    
    @State var photoSelection: PhotosPickerItem?
    
    let project: Project?
    
    @State private var createError: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var moc
    
    init(project: Project? = nil) {
        self.project = project
        
        if let project {
            _titleProject = State(initialValue: project.getName())
            _descriptionProject = State(initialValue: project.getDescriptionText())
            _startDate = State(initialValue: project.getStart())
            _endDate = State(initialValue: project.getEnd())
            _isFavorite = State(initialValue: project.getFavorite())
            _color = State(initialValue: Int(project.color))
            
            if let data = project.image, let uiImage = UIImage(data: data) {
                _imageData = State(initialValue: data)
                _image = State(initialValue: Image(uiImage: uiImage))
            } else {
                _imageData = State(initialValue: nil)
                _image = State(initialValue: nil)
            }
            
        } else {
            _titleProject = State(initialValue: "")
            _descriptionProject = State(initialValue: "")
            _startDate = State(initialValue: Date())
            _endDate = State(initialValue: Date())
            _isFavorite = State(initialValue: false)
            _color = State(initialValue: 0)
            
            _imageData = State(initialValue: nil)
            _image = State(initialValue: nil)
        }
        
        _createError = State(initialValue: false)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                HStack{
                    Spacer()
                    PhotosPicker(selection: $photoSelection, matching: .images) {
                        Group {
                            if let image {
                                 image
                                     .resizable()
                                     .scaledToFill()
                                     .frame(width: 200, height: 200)
                                     .clipShape(
                                        RoundedRectangle(cornerRadius: 26)
                                     )
                            } else {
                                Image(systemName: "photo.badge.plus")
                                    .font(.title.bold())
                                    .foregroundStyle(Color.lightBlue)
                                    .frame(width: 200, height: 200)
                                    .background (
                                        RoundedRectangle(cornerRadius: 26)
                                            .fill(Color(.secondarySystemBackground))
                                            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 0)
                                    )
                            }
                        }
                    }
                    // https://stackoverflow.com/questions/79331226/how-to-use-a-photo-picker-and-display-the-selected-photo-within-a-single-sheet-i
                    .onChange(of: photoSelection) { oldValue, newValue in
                        guard let newValue else { return }
                        changeImage(to: newValue)
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
                
                Section (header: Text("Título do Projeto")){
                    TextField("Título", text: $titleProject)
                }
                
                Section (header: Text("Descrição do Projeto")){
                    TextField("Digite aqui a descrição do seu projeto.", text: $descriptionProject, axis: .vertical)
                        .lineLimit(6...6)
                }
                
                Section (header: Text("Lembrete")){
                    HStack {
                        Text("Favoritar")
                        Spacer()
                        Favorite(isFavorite: $isFavorite)
                    }
                    if (image == nil) {
                        HStack {
                            Text("Cor")
                            Spacer()
                            ColorPickerView(colorValue: $color)
                        }
                    }
                     HStack {
                        Text("Começa")
                        DatePicker("", selection: $startDate)
                            .onChange(of: startDate) {
                                if (endDate < startDate) {
                                    endDate = startDate
                                }
                            }
                    }
                    HStack {
                        Text("Termina")
                        DatePicker("", selection: $endDate)
                    }
                }
                
            }
            .navigationTitle("Novo Projeto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("", systemImage: "xmark", role: .cancel) {
                        
                        dismiss()
                        
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("", systemImage: "checkmark", role: .confirm) {
                        
                        if (titleProject.isEmpty || descriptionProject.isEmpty) {
                            createError.toggle()
                        } else {
                            
                            let projeto = project ?? Project(context: moc)
                            
                            projeto.name = titleProject
                            projeto.descriptionText = descriptionProject
                            projeto.id_project = project == nil ? UUID() : projeto.id_project
                            projeto.favorite = isFavorite
                            projeto.start = startDate
                            projeto.color = Int64(color)
                            if (image == nil) {
                                projeto.image = nil
                            } else {
                                projeto.image = imageData
                            }
                            projeto.end = endDate
                            
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
            .presentationDragIndicator(.visible)
            .alert("Error", isPresented: $createError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Por favor preencher todos os campos no formulário")
            }
        }
    }
    
    func changeImage(to pickerItem: PhotosPickerItem) {
        Swift.Task {
            do {
                self.imageData = try await pickerItem.loadTransferable(type: Data.self)
                
                guard let inputImage = UIImage(data: imageData!) else { return }
                
                self.image = Image(uiImage: inputImage)
            } catch {
                print("Error converting image to ")
            }
        }
    }
}

#Preview {
    SheetNewProject()
        .sheet(isPresented: .constant(true)) {
            SheetNewProject()
        }
}
