//
//  PersistenceController.swift
//  TODO
//
//  Created by 오정석 on 5/11/2025.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "TodoModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("CoreData 로드 실패: \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
}
