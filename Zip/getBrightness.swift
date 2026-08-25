//
//  getBrightness.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 21/08/26.
//

// idk where to put this so it'll stay in the root ig

import Foundation
import UIKit

// https://gist.github.com/adamcichy/2d00c7a54009b4a9751ba513749c485e
func getBrightness(for image: UIImage) -> Int? {
    guard let cgImage = image.cgImage,
        let imageData = cgImage.dataProvider?.data,
        let dataPointer = CFDataGetBytePtr(imageData)
    else {
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
