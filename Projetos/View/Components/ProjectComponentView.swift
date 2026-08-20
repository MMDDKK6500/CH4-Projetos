//
//  ProjectComponentView.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 18/08/26.
//

import SwiftUI

struct ProjectComponentView: View {

    let project: Project
    
    let uiImage: UIImage
    
    var brightness: Int = 0
    
    init(project: Project) {
        self.project = project
        uiImage = UIImage(data: project.image!)!
        brightness = getBrightness(for: uiImage)!
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                VStack {
                    Text("Prazo Final")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            Color(brightness > 128 ? .black : .white)
                        )
                    Text(project.end!.formatted(.dateTime.day()))
                        .font(.system(size: 48))
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            Color(brightness > 128 ? .black : .white)
                        )
                    Text(project.end!.formatted(.dateTime.month().year()))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            Color(brightness > 128 ? .black : .white)
                        )
                }

                Text(project.name!)
                    .lineLimit(2)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        Color(brightness > 128 ? .black : .white)
                    )
            }
            Spacer()
        }
        .padding()
        .glassEffect(.clear, in: .rect(cornerRadius: 26))
        .background(
            Image(uiImage: UIImage(data: project.image!)!)
                .resizable()
                .scaledToFill()
        )
        .clipShape(
            .rect(cornerRadius: 26)
        )
    }
    
    // https://gist.github.com/adamcichy/2d00c7a54009b4a9751ba513749c485e
    func getBrightness(for image: UIImage) -> Int? {
            guard let cgImage = image.cgImage,
                  let imageData = cgImage.dataProvider?.data,
                  let dataPointer = CFDataGetBytePtr(imageData) else {
                return nil
            }
            let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
            let dataLength = CFDataGetLength(imageData)
            var result = 0.0
            for i in stride(from: 0, to: dataLength, by: bytesPerPixel) {
                let r = dataPointer[i]
                let g = dataPointer[i + 1]
                let b = dataPointer[i + 2]
                result += 0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b)
            }
            let pixelsCount = dataLength / bytesPerPixel
            let brightness = Int(result) / pixelsCount
            return brightness
    }
}
