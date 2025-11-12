//
//  FetchTodoUseCaseTests.swift
//  TODOTests
//
//  Created by 오정석 on 10/11/2025.
//

import XCTest
import Combine
@testable import TODO

final class FetchTodoUseCaseTests: XCTestCase {
    var sut: FetchTodosUseCase!
    var mockRepository: MockTodoRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockTodoRepository()
        sut = FetchTodosUseCase(repository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_할일목록_불러오기_성공() async throws {
        // Given: 샘플 데이터 준비
        mockRepository.addSampleTodos(count: 3)
        
        // When: UseCase 실행
        let todos = try await sut.execute()
        
        // Then: 검증
        XCTAssertEqual(todos.count, 3, "할 일이 3개여야 함")
        XCTAssertEqual(todos[0].title, "테스트 할 일 1")
    }
    
    func test_빈목록_반환() async throws {
        // Given: 빈 Repository
        
        // When
        let todos = try await sut.execute()
        
        // Then
        XCTAssertTrue(todos.isEmpty, "초기 상태는 비어있어야 함")
    }
    
    func test_필터링_진행중만() async throws {
        // Given
        mockRepository.addSampleTodos(count: 4)
        // (짝수 인덱스는 완료됨
        
        // When
        let todos = try await sut.execute(filter: .active)
        
        // Then
        XCTAssertEqual(todos.count, 2, "진행중인 할 일만 2개")
        XCTAssertFalse(todos[0].isCompleted)
    }
    
    func test_에러발생시_throw() async throws {
        // Given
        mockRepository.shouldFail = true
        mockRepository.errorToThrow = RepositoryError.notFound
        
        // When & Then
        do {
            _ = try await sut.execute()
            XCTFail("에러가 발생해야 함")
        } catch let error as RepositoryError {
            XCTAssertEqual(error, .notFound)
        } catch {
            XCTFail("에상치 못한 에러: \(error)")
        }
    }
}
