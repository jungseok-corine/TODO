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
    
    func fetchAll() -> AnyPublisher<[TodoItem], any Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "RepositoryError", code: 0)))
                return
            }
            
            let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
            
            // 정렬: 생성일 기준 내림차순
            request.sortDescriptors = [
                NSSortDescriptor(key: "createdAt", ascending: false)
            ]
            do {
                let entities = try context.fetch(request)
                let todos = entities.map { entity in
                    TodoItem(
                        id: entity.id ?? UUID(),
                        title: entity.title ?? "",
                        detail: entity.detail,
                        isCompleted: entity.isCompleted,
                        createdAt: entity.createdAt ?? Date(),
                        priority: Int(entity.priority)
                    )
                }
                promise(.success(todos))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func add(_ todo: TodoItem) -> AnyPublisher<Void, any Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "RepositoryError", code: 0)))
                return
            }
            let entity = TodoEntity(context: context)
            entity.id = todo.id
            entity.title = todo.title
            entity.detail = todo.detail
            entity.isCompleted = todo.isCompleted
            entity.createdAt = todo.createdAt
            entity.priority = Int16(todo.priority)
            
            do {
                try self.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update(_ todo: TodoItem) -> AnyPublisher<Void, any Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "RepositoryError", code: 0)))
                return
            }
            
            let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
            request.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
            do {
                
                guard let entity = try context.fetch(request).first else {
                    promise(.failure(NSError(domain: "TodoNotFound", code: 404)))
                    return
                }
                
                entity.title = todo.title
                entity.detail = todo.detail
                entity.isCompleted = todo.isCompleted
                entity.updatedAt = Date()
                entity.priority = Int16(todo.priority)
                
                try self.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete(id: UUID) -> AnyPublisher<Void, any Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "Repository", code: 0)))
                return
            }
            let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                guard let entity = try context.fetch(request).first else {
                    promise(.failure(NSError(domain: "TodoNotFound", code: 404)))
                    return
                }
                
                context.delete(entity)
                
                try context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
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
