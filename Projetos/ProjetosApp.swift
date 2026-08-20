//
//  ProjetosApp.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 13/08/26.
//

import SwiftUI
internal import CoreData

@main
struct ProjetosApp: App {
    
    @StateObject private var dataController = DataController()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    NavigationStack {
                        HomeView()
                    }
                } else {
                    WelcomeView()
                }
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
