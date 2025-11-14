//
//  CoreDataTodoRepository.swift
//  TODO
//
//  Created by 오정석 on 5/11/2025.
//

//import Foundation
import CoreData
import Combine

class CoreDataTodoRepository: TodoRepositoryProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAll() async throws -> [TodoItem] {
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        
        // 정렬: 생성일 기준 내림차순
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        
        let entities = try context.fetch(request)
        return entities.map { entity in
            TodoItem(
                id: entity.id ?? UUID(),
                title: entity.title ?? "",
                detail: entity.detail,
                isCompleted: entity.isCompleted,
                createdAt: entity.createdAt ?? Date(),
                priority: Int(entity.priority)
            )
        }
    }
    
    func add(_ todo: TodoItem) async throws {
        let entity = TodoEntity(context: context)
        entity.id = todo.id
        entity.title = todo.title
        entity.detail = todo.detail
        entity.isCompleted = todo.isCompleted
        entity.createdAt = todo.createdAt
        entity.priority = Int16(todo.priority)
        
        try context.save()
    }
    
    func update(_ todo: TodoItem) async throws {
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        request.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
        
        guard let entity = try context.fetch(request).first else {
            throw RepositoryError.notFound
        }
        
        entity.title = todo.title
        entity.detail = todo.detail
        entity.isCompleted = todo.isCompleted
        entity.updatedAt = Date()
        entity.priority = Int16(todo.priority)
        
        try self.context.save()
    }
    
    func delete(id: UUID) async throws {
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        guard let entity = try context.fetch(request).first else {
            throw RepositoryError.notFound
        }
        
        context.delete(entity)
        try context.save()
    }
}

extension CoreDataTodoRepository {
    // 완료되지 않은 TODO만 조회
    func fetchIncompleteTodos() async throws -> [TodoItem] {
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        request.predicate = NSPredicate(format: "isCompleted == false")
        request.sortDescriptors = [
            NSSortDescriptor(key: "priority", ascending: false),
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        
        let entities = try context.fetch(request)
        return entities.map { entity in
            TodoItem(
                id: entity.id ?? UUID(),
                title: entity.title ?? "",
                detail: entity.detail,
                isCompleted: entity.isCompleted,
                createdAt: entity.createdAt ?? Date(),
                priority: Int(entity.priority)
            )
        }
    }
    
    // 검색 기능
    func searchTodos(query: String) async throws -> [TodoItem] {
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        request.predicate = NSPredicate(
            format: "title CONTAINS[cd] %@ OR detail CONTAINS[cd] %@",
            query, query
        )
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        
        let entities = try context.fetch(request)
        return entities.map { entity in
            TodoItem(
                id: entity.id ?? UUID(),
                title: entity.title ?? "",
                detail: entity.detail,
                isCompleted: entity.isCompleted,
                createdAt: entity.createdAt ?? Date(),
                priority: Int(entity.priority)
            )
        }
    }
}
