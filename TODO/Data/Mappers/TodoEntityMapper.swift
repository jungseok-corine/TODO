//
//  TodoEntityMapper.swift
//  TODO
//
//  Created by 오정석 on 15/11/2025.
//

import CoreData

struct TodoEntityMapper {
    
    // MARK: - Entity -> Domain Model
    static func toDomain(_ entity: TodoEntity) -> TodoItem {
        TodoItem(
            id: entity.id ?? UUID(),
            title: entity.title ?? "",
            detail: entity.detail,
            isCompleted: entity.isCompleted,
            createdAt: entity.createdAt ?? Date(),
            updatedAt: entity.updatedAt,
            priority: Int(entity.priority)
        )
    }
    
    // MARK: - Domain Model -> Entity
    static func toEntity(_ item: TodoItem, context: NSManagedObjectContext) -> TodoEntity {
        let entity = TodoEntity(context: context)
        entity.id = item.id
        entity.title = item.title
        entity.detail = item.detail
        entity.isCompleted = item.isCompleted
        entity.createdAt = item.createdAt
        entity.updatedAt = item.updatedAt
        entity.priority = Int16(item.priority)
        return entity
    }
    
    // MARK: - Update Entity
    static func update(_ entity: TodoEntity, with item: TodoItem) {
        entity.title = item.title
        entity.detail = item.detail
        entity.isCompleted = item.isCompleted
        entity.priority = Int16(item.priority)
        entity.updatedAt = Date()
    }
}
