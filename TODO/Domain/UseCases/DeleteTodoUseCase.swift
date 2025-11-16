//
//  DeleteTodoUseCase.swift
//  TODO
//
//  Created by 오정석 on 3/11/2025.
//

import Foundation

class DeleteTodoUseCase {
    private let repository: TodoRepositoryProtocol
    
    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: UUID) async throws {
        try await repository.deleteTodo(id: id)
    }
}
