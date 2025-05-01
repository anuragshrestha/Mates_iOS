//
//  MatesApp.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//

import SwiftUI

@main
struct MatesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView{
                LaunchView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
