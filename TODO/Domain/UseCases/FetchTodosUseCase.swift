//
//  FetchTodoUseCase.swift
//  TODO
//
//  Created by 오정석 on 3/11/2025.
//

import Foundation

/// 할 일 목록 불러오기 UseCase
/// - Note: 비즈니스 로직만 담당
class FetchTodosUseCase {
    private let repository: TodoRepositoryProtocol
    
    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(filter: TodoFilter = .all) async throws -> [TodoItem] {
        let todos = try await repository.fetchAll()
        
        switch filter {
        case .all:
            return todos
        case .active:
            return todos.filter { !$0.isCompleted }
        case .completed:
            return todos.filter { $0.isCompleted }
        }
    }
}
