//
//  DIContainer.swift
//  TODO
//
//  Created by 오정석 on 3/11/2025.
//

import CoreData

class DIContainer {
    
    static let shared = DIContainer()
    
    private let context: NSManagedObjectContext
    
    private init() {
        self.context = PersistenceController.shared.viewContext
    }
    
    // MARK: - Repositories
    
    /// TdodoRepository 인스턴스 (전역에서 하나만 사용)
    func makeTodoRepository() -> TodoRepositoryProtocol {
        CoreDataTodoRepository(context: context)
    }
    
    // MARK: - UseCases
    
//    func makeFetchTodosUseCase() -> FetchTodosUseCase {
//        FetchTodosUseCase(repository: makeTodoRepository())
//    }
    
    func makeAddTodoUseCase() -> AddTodoUseCase {
        AddTodoUseCase(repository: makeTodoRepository())
    }
    
    func makeToggleTodoUseCase() -> ToggleTodoUseCase {
        ToggleTodoUseCase(repository: makeTodoRepository())
    }
    
    func makeDeleteTodoUseCase() -> DeleteTodoUseCase {
        DeleteTodoUseCase(repository: makeTodoRepository())
    }
    
    // MARK: - ViewModels
    
    /// TodoViewModel 생성
    func makeTodoViewModel() -> TodoViewModel {
        TodoViewModel(
            repository: CoreDataTodoRepository(), addTodoUseCase: makeAddTodoUseCase(),
            toggleTodoUseCase: makeToggleTodoUseCase(),
            deleteTodoUseCase: makeDeleteTodoUseCase()
        )
    }
    
    func makeTodoViewModel(todoRepository: TodoRepositoryProtocol) -> TodoViewModel {
        TodoViewModel(
            repository: CoreDataTodoRepository(),
            addTodoUseCase: makeAddTodoUseCase(),
            toggleTodoUseCase: makeToggleTodoUseCase(),
            deleteTodoUseCase: makeDeleteTodoUseCase()
        )
    }
}
