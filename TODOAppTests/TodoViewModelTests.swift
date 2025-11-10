//
//  TodoViewModelTests.swift
//  TODOTests
//
//  Created by 오정석 on 10/11/2025.
//

import XCTest
@testable import TODO

final class TodoViewModelTests: XCTestCase {
    var sut: TodoViewModel!
    var mockRepository: TodoRepositoryProtocol!
    
    // 각 테스트 전에 실행
    override func setUp()  {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        mockRepository = MockTodoRepository()
        
        let fetchUseCase = FetchTodosUseCase(repository: mockRepository)
        let addUseCase = AddTodoUseCase(repository: mockRepository)
        let toggleUseCase = ToggleTodoUseCase(repository: mockRepository)
        let deleteUseCase = DeleteTodoUseCase(repository: mockRepository)
        
        sut = TodoViewModel(
            fetchTodosUseCase: fetchUseCase,
            addTodoUseCase: addUseCase,
            toggleTodoUseCase: toggleUseCase,
            deleteTodoUseCase: deleteUseCase
        )
    }
    // 각 테스트 후에 실행
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
