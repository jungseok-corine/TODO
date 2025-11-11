//
//  ToggleTodoUseCase.swift
//  TODO
//
//  Created by 오정석 on 3/11/2025.
//

import Foundation
import Combine

class ToggleTodoUseCase {
    private let repository: TodoRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(todo: TodoItem) async throws {
        var updatedTodo = todo
        updatedTodo.isCompleted.toggle()
        return try await withCheckedThrowingContinuation { continuation in
            var hasResumed = false
            
            repository.update(updatedTodo)
                .sink(
                    receiveCompletion: { completion in
                        guard !hasResumed else { return }
                        hasResumed = true
                        
                        switch completion {
                        case .finished:
                            continuation.resume()
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { _ in }
                )
                .store(in: &self.cancellables)
        }
    }
}
