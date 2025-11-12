//
//  DeleteTodoUseCaseTests.swift
//  TODOTests
//
//  Created by 오정석 on 12/11/2025.
//

import XCTest
import Combine
@testable import TODO

final class DeleteTodoUseCaseTests: XCTestCase {
    
    var sut: DeleteTodoUseCase!
    var mockRepository: MockTodoRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockTodoRepository()
        sut = DeleteTodoUseCase(repository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_할일삭제_성공() async throws {
        // Given
        mockRepository.addSampleTodos(count: 3)
        let todoToDelete = mockRepository.todos[1]
        
        // When
        try await sut.execute(id: todoToDelete.id)
        
        // Then
        XCTAssertEqual(mockRepository.todos.count, 2)
        XCTAssertFalse(mockRepository.todos.contains(where: { $0.id == todoToDelete.id }))
    }
    
    func test_존재하지않는_할일_삭제시_에러() async {
        // Given
        let nonExistentId = UUID()
        
        // When & Then
        do {
            try await sut.execute(id: nonExistentId)
            XCTFail("존재하지 않는 할 일 삭제 시 에러가 발생해야 함")
        } catch {
            XCTAssertTrue(error is RepositoryError)
        }
    }
    
    func test_Repository_실패시_에러전파() async {
        // Given
        mockRepository.addSampleTodos(count: 1)
        let todo = mockRepository.todos[0]
        mockRepository.shouldFail = true
        
        // When & Then
        do {
            try await sut.execute(id: todo.id)
            XCTFail("Repository 실패시 에러가 전파되어야 함")
        } catch {
            XCTAssertTrue(true)
        }
    }
}
