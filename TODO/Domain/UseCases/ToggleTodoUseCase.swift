//
//  ToggleTodoUseCase.swift
//  TODO
//
//  Created by 오정석 on 3/11/2025.
//

import Foundation

class ToggleTodoUseCase {
    private let repository: TodoRepositoryProtocol
    
    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(todo: TodoItem) async throws {
        var updatedTodo = todo
        updatedTodo.isCompleted.toggle()
        try await repository.update(updatedTodo)
    }
}
