//
//  AddTodoUseCase.swift
//  TODO
//
//  Created by 오정석 on 3/11/2025.
//

import Foundation

class AddTodoUseCase {
    private let repository: TodoRepositoryProtocol
    
    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(title: String) async throws {
        guard !title.isEmpty else {
            throw TodoError.emptyTitle
        }
        
        let todo = TodoItem(title: title)
        try await repository.add(todo)
    }
}
