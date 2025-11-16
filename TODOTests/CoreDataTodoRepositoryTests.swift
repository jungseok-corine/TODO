//
//  CoreDataTodoRepository.swift
//  TODOTests
//
//  Created by 오정석 on 16/11/2025.
//

import XCTest
import CoreData
@testable import TODO

final class CoreDataTodoRepositoryTests: XCTestCase {
    var sut: CoreDataTodoRepository!
    var testStack: CoreDataTestStack!
    
    override func setUp() {
        super.setUp()
        print("✅ setUp 시작")
        
        testStack = CoreDataTestStack.shared
        testStack.reset()
        sut = CoreDataTodoRepository(context: testStack.context)
        
        print("✅ setUp 완료")
    }
    
    override func tearDown() {
        print("✅ tearDown 시작")
        
        sut = nil
        testStack.reset()
        
        print("✅ tearDown 완료")
        super.tearDown()
    }
    
    // MARK: - 할일 추가 테스트
    func test_할일추가_성공() async throws {
        print("🧪 test_할일추가_성공 시작")
        
        // Given
        let todo = TodoItem(title: "Test Todo")
        print("  Given: todo 생성 완료")
        
        // When
        try await sut.addTodo(todo)
        print("  When: addTodo 완료")
        
        let todos = try await sut.fetchTodos()
        print("  When: fetchTodos 완료 - count: \(todos.count)")
        
        // Then
        XCTAssertEqual(todos.count, 1, "Todo 개수가 1개여야 함")
        XCTAssertEqual(todos.first?.title, "Test Todo", "Title이 일치해야 함")
        
        print("🧪 test_할일추가_성공 완료 ✅")
    }
    
    func test_할일조회_성공() async throws {
        print("🧪 test_할일조회_성공 시작")
        
        // Given
        let todo1 = TodoItem(title: "Todo 1")
        let todo2 = TodoItem(title: "Todo 2")
        
        try await sut.addTodo(todo1)
        try await sut.addTodo(todo2)
        print("  Given: 2개 todo 추가 완료")
        
        // When
        let todos = try await sut.fetchTodos()
        print("  When: fetchTodos 완료 - count: \(todos.count)")
        
        // Then
        XCTAssertEqual(todos.count, 2, "Todo 개수가 2개여야 함")
        
        print("🧪 test_할일조회_성공 완료 ✅")
    }
    
    func test_할일업데이트_성공() async throws {
        print("🧪 test_할일업데이트_성공 시작")
        
        // Given
        var todo = TodoItem(title: "Original")
        try await sut.addTodo(todo)
        print("  Given: todo 추가 완료")
        
        // When
        todo.title = "Updated"
        todo.isCompleted = true
        try await sut.updateTodo(todo)
        print("  When: updateTodo 완료")
        
        let todos = try await sut.fetchTodos()
        print("  When: fetchTodos 완료")
        
        // Then
        XCTAssertEqual(todos.first?.title, "Updated", "Title이 업데이트되어야 함")
        XCTAssertTrue(todos.first?.isCompleted ?? false, "isCompleted가 true여야 함")
        
        print("🧪 test_할일업데이트_성공 완료 ✅")
    }
    
    func test_할일삭제_성공() async throws {
        print("🧪 test_할일삭제_성공 시작")
        
        // Given
        let todo = TodoItem(title: "To Delete")
        try await sut.addTodo(todo)
        print("  Given: todo 추가 완료")
        
        // When
        try await sut.deleteTodo(id: todo.id)
        print("  When: deleteTodo 완료")
        
        let todos = try await sut.fetchTodos()
        print("  When: fetchTodos 완료 - count: \(todos.count)")
        
        // Then
        XCTAssertTrue(todos.isEmpty, "Todo가 삭제되어야 함")
        
        print("🧪 test_할일삭제_성공 완료 ✅")
    }
    
    // 먼저 이 간단한 테스트가 통과하는지 확인
    func test_Context_생성_확인() {
        print("🧪 test_Context_생성_확인 시작")
        
        XCTAssertNotNil(testStack, "testStack이 nil이면 안됨")
        XCTAssertNotNil(testStack.context, "context가 nil이면 안됨")
        XCTAssertNotNil(sut, "sut이 nil이면 안됨")
        
        print("🧪 test_Context_생성_확인 완료 ✅")
    }

    func test_Entity_생성_확인() {
        print("🧪 test_Entity_생성_확인 시작")
        
        // TodoEntity가 제대로 생성되는지 확인
        let entity = TodoEntity(context: testStack.context)
        entity.id = UUID()
        entity.title = "Test"
        entity.isCompleted = false
        entity.createdAt = Date()
        entity.priority = 1
        
        XCTAssertNotNil(entity, "Entity가 생성되어야 함")
        XCTAssertEqual(entity.title, "Test", "Title이 설정되어야 함")
        
        print("🧪 test_Entity_생성_확인 완료 ✅")
    }
}
