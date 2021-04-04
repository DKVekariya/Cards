//
//  CardsApp.swift
//  Cards
//
//  Created by Divyesh Vekariya on 04/04/21.
//

import SwiftUI

@main
struct CardsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
