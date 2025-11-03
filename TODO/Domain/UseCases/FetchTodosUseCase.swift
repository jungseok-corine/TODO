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
    
    func execute() async throws -> [TodoItem] {
        return try await repository.fetchAll()
    }
}
