//
//  SearchTodosUseCase.swift
//  TODO
//
//  Created by 오정석 on 17/11/2025.
//

import Foundation

class SearchTodosUseCase {
    private let repository: CoreDataTodoRepository
    
    init(repository: CoreDataTodoRepository) {
        self.repository = repository
    }
    
    func execute(query: String, filter: TodoFilter, sortOption: TodoSortOption) async throws -> [TodoItem] {
        let predicate = buildPredicate(query: query, filter: filter)
        let sortDescriptions = buildSortDescriptors(sortOption)
        
        return try await repository.fetchTodos(
            predicate: predicate,
            sortDescriptions: sortDescriptions
        )
    }
    
    private func buildPredicate(query: String, filter: TodoFilter) -> NSPredicate {
        var predicates: [NSPredicate] = []
        
        // 검색 쿼리
        if !query.isEmpty {
            let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
            let detailPredicate = NSPredicate(format: "detail CONTAINS[cd] %@", query)
            predicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, detailPredicate]))
        }
        
        // 필터
        switch filter {
        case .all:
            break
        case .active:
            predicates.append(NSPredicate(format: "isCompleted == false"))
        case .completed:
            predicates.append(NSPredicate(format: "isCompleted == true"))
        case .highPriority:
            predicates.append(
                NSPredicate(format: "priority >= 3")
            )
        case .today:
            let start = Calendar.current.startOfDay(for: Date())
            let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
            predicates.append(
                NSPredicate(format: "createdAt >= %@ AND createdAt < %@",
                            start as NSDate, end as NSDate)
            )
        case .thisWeek:
            let start = Calendar.current.dateInterval(of: .weekOfYear, for: Date())!.start
            let end = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: start)!
            predicates.append(
                NSPredicate(format: "createdAt >= %@ AND createdAt < %@",
                            start as NSDate, end as NSDate)
            )
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
    }
    
    private func buildSortDescriptors(_ option: TodoSortOption) -> [NSSortDescriptor] {
        switch option {
        case .dateDescending:
            return [NSSortDescriptor(keyPath: \TodoEntity.createdAt, ascending: false)]
        case .dateAscending:
            return [NSSortDescriptor(keyPath: \TodoEntity.createdAt, ascending: true)]
        case .title:
            return [NSSortDescriptor(keyPath: \TodoEntity.title, ascending: true)]
        case .priority:
            return [
                NSSortDescriptor(keyPath: \TodoEntity.priority, ascending: false),
                NSSortDescriptor(keyPath: \TodoEntity.createdAt, ascending: false)
            ]
        }
    }
}
