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
    
    init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
    }
    
    func fetchTodos() async throws -> [TodoItem] {
        let request = TodoEntity.fetchRequest()
        // 정렬: 생성일 기준 내림차순
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TodoEntity.createdAt, ascending: false)
        ]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { TodoEntityMapper.toDomain($0) }
        } catch {
            print("❌ Fetch 실패: \(error)")
            throw TodoError.fetchFailed
        }
    }
    
    func addTodo(_ todo: TodoItem) async throws {
        _ = TodoEntityMapper.toEntity(todo, context: context)
        
        do {
            try context.save()
            print("✅ Todo 추가 성공: \(todo.title)")
        } catch {
            context.rollback()
            print("❌ Todo 추가 실패: \(error)")
            throw TodoError.saveFailed
        }
    }
    
    func updateTodo(_ todo: TodoItem) async throws {
        let request = TodoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
        
        do {
            let entities = try context.fetch(request)
            guard let entity = entities.first else {
                throw RepositoryError.notFound
            }
            
            TodoEntityMapper.update(entity, with: todo)
            try self.context.save()
            print("✅ Todo 업데이트 성공: \(todo.title)")
        } catch {
            context.rollback()
            print("❌ Todo 업데이트 실패: \(error)")
            throw TodoError.updateFailed
        }
    }
    
    func deleteTodo(id: UUID) async throws {
        let request = TodoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try context.fetch(request)
            guard let entity = entities.first else {
                throw TodoError.notFound
            }
            
            context.delete(entity)
            try context.save()
            print("✅ Todo 삭제 성공: \(id)")
        } catch {
            context.rollback()
            print("❌ Todo 삭제 실패: \(error)")
            throw TodoError.deleteFailed
        }
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
