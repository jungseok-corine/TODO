//
//  DIContainer.swift
//  TODO
//
//  Created by 오정석 on 3/11/2025.
//

import Foundation

class DIContainer {
    
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Repositories
    
    /// TdodoRepository 인스턴스 (전역에서 하나만 사용)
    private lazy var todoRepository: TodoRepositoryProtocol = {
        TodoRepository.shared
    }()
    
    // MARK: - UseCases
    
    func makeFetchTodosUseCase() -> FetchTodosUseCase {
        FetchTodosUseCase(repository: todoRepository)
    }
    
    func makeAddTodoUseCase() -> AddTodoUseCase {
        AddTodoUseCase(repository: todoRepository)
    }
    
    func makeToggleTodoUseCase() -> ToggleTodoUseCase {
        ToggleTodoUseCase(repository: todoRepository)
    }
    
    func makeDeleteTodoUseCase() -> DeleteTodoUseCase {
        DeleteTodoUseCase(repository: todoRepository)
    }
    
    // MARK: - ViewModels
    
    /// TodoViewModel 생성
    func makeTodoViewModel() -> TodoViewModel {
        TodoViewModel(
            fetchTodosUseCase: makeFetchTodosUseCase(),
            addTodoUseCase: makeAddTodoUseCase(),
            toggleTodoUseCase: makeToggleTodoUseCase(),
            deleteTodoUseCase: makeDeleteTodoUseCase()
        )
    }
}
