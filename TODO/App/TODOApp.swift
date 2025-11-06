//
//  TODOApp.swift
//  TODO
//
//  Created by 오정석 on 29/10/2025.
//

import SwiftUI

@main
struct TODOApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            TodoListView()
                .environment(\.managedObjectContext,
                              persistenceController.viewContext)
        }
    }
}
