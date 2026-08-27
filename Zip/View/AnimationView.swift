//
//  StarAnimationView.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 25/08/26.
//
import SwiftUI

struct AnimationView: View {
    let imageName: String
    let totalFrames: Int
    let fps: Double
    var holdFrame: Int? = nil
    var holdDuration: Double = 0.0

    var onComplete: (() -> Void)? = nil

    @State private var currentFrame = 1
    @State private var timer: Timer? = nil

    var body: some View {
        Image("\(imageName)\(currentFrame)")
            .resizable()
            .scaledToFit()
            .onAppear {
                runAnimation()
            }
            .onDisappear {
                stopTimer()
            }
    }

    private func runAnimation() {
        let interval = 1.0 / fps

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true)
        { _ in
            if let hold = holdFrame, currentFrame == hold {
                stopTimer()

                DispatchQueue.main.asyncAfter(deadline: .now() + holdDuration) {
                    currentFrame += 1
                    runAnimation()
                }
            } else if currentFrame < totalFrames {
                currentFrame += 1
            } else {
                stopTimer()
                DispatchQueue.main.async {
                    onComplete?()
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
