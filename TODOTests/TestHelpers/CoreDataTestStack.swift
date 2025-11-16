//
//  CoreDataTestStack.swift
//  TODOTests
//
//  Created by 오정석 on 16/11/2025.
//

import CoreData
@testable import TODO

class CoreDataTestStack {
    static let shared = CoreDataTestStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoModel")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        var loadError: Error?
        container.loadPersistentStores { _, error in
            if let error = error {
                loadError = error
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        
        if let error = loadError {
            fatalError("Failed to create in-memory store: \(error)")
        }
        
        // ViewContext 설정
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    /// 모든 TodoEntity 삭제
    func reset() {
        let fetchRequest = TodoEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(fetchRequest)
            
            // 각 Entity를 하나씩 삭제
            for entity in entities {
                context.delete(entity)
            }
            
            // 변경사항 저장
            if context.hasChanges {
                try context.save()
            }
            
            print("✅ Reset 완료: \(entities.count)개 삭제")
            
        } catch {
            print("❌ Reset 실패: \(error)")
            
            // Reset 실패시 롤백
            context.rollback()
        }
    }
    
    /// 특정 Entity만 삭제
    func deleteAll<T: NSManagedObject>(_ type: T.Type) throws {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type))
        let entities = try context.fetch(fetchRequest)
        
        entities.forEach { context.delete($0) }
        
        if context.hasChanges {
            try context.save()
        }
    }
}

