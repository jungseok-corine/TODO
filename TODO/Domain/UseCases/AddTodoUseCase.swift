//
//  AddTodoUseCase.swift
//  TODO
//
//  Created by 오정석 on 3/11/2025.
//

import Foundation
import Combine

class AddTodoUseCase {
    private let repository: TodoRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(title: String) async throws {
        guard !title.isEmpty else {
            throw TodoError.emptyTitle
        }
        
        let todo = TodoItem(title: title)
        
        return try await withCheckedThrowingContinuation { continuation in
            var hasResumed = false
            
            repository.add(todo)
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
