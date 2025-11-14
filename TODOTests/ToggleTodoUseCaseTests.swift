//
//  ToggleTodoUseCaseTests.swift
//  TODOTests
//
//  Created by 오정석 on 10/11/2025.
//

import XCTest
import Combine
@testable import TODO

final class ToggleTodoUseCaseTests: XCTestCase {
    var sut: ToggleTodoUseCase!
    var mockRepository: MockTodoRepository!
    var cancellable: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockTodoRepository()
        sut = ToggleTodoUseCase(repository: mockRepository)
        cancellable = []
    }
    
    override func tearDown() {
        cancellable = nil
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    @MainActor
    func test_미완료_를_완료로_토글() async throws {
        // Given
        let todo = TodoItem(title: "테스트", isCompleted: false)
        mockRepository.todos = [todo]
        
        // When
        try await sut.execute(todo: todo)
        
        // Then
        let updated = mockRepository.todos.first!
        XCTAssertTrue(updated.isCompleted, "완료 상태가 되어야 함")
    }
    
    func test_존재하지않는_할일_토글시_에러() async {
        // Given
        let todo = await TodoItem(title: "존재하지 않음")
        // Repository는 비어있음
        
        // When & Then
        do {
            try await sut.execute(todo: todo)
            XCTFail("존재하지 않는 할 일은 에러가 발생해야 함")
        } catch let error as RepositoryError {
            XCTAssertEqual(error, .notFound)
        } catch {
            XCTFail("에상치 못한 에러")
        }
    }
}
