//
//  AddTodoUseCaseTests.swift
//  TODOTests
//
//  Created by 오정석 on 10/11/2025.
//

import XCTest
import Combine
@testable import TODO

final class AddTodoUseCaseTests: XCTestCase {
    
    var sut: AddTodoUseCase!
    var mockRepository: MockTodoRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockTodoRepository()
        sut = AddTodoUseCase(repository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_할일추가_성공() async throws {
        // Given
        let title = "테스트 할 일"
        
        // When
        try await sut.execute(title: title)
        
        // Then
        XCTAssertEqual(mockRepository.todos.count, 1)
        XCTAssertEqual(mockRepository.todos.first?.title, title)
        XCTAssertFalse(mockRepository.todos.first!.isCompleted)
    }
    
    func test_빈제목_에러() async throws {
        // Given
        let title = ""
        
        // When & Then
        do {
            try await sut.execute(title: title)
            XCTFail("빈 제목은 에러가 발생해야 함")
        } catch let error as TodoError {
            XCTAssertEqual(error, .emptyTitle)
        } catch {
            XCTFail("에상치 못한 에러")
        }
    }
    
    func test_Repository_실패시_에러전파() async {
        // Given
        mockRepository.shouldFail = true
        
        // When & Then
        do {
            try await sut.execute(title: "테스트")
            XCTFail("Repository 실패시 에러가 전파되어야 함")
        } catch {
            // 에러가 정상적으로 throw 됨
            XCTAssertTrue(true)
        }
    }
}
