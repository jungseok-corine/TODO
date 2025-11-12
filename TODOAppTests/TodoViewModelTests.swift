//
//  TodoViewModelTests.swift
//  TODOTests
//
//  Created by 오정석 on 10/11/2025.
//

import XCTest
import Combine
@testable import TODO

@MainActor
final class TodoViewModelTests: XCTestCase {
    var sut: TodoViewModel!
    var mockRepository: MockTodoRepository!
    var cancellables: Set<AnyCancellable>!
    
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
        
        cancellables = []
    }
    // 각 테스트 후에 실행
    override func tearDown() {
        cancellables = nil
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - 초기 상태 테스트
    func test_초기상태_할일목록_비어있음() {
        XCTAssertTrue(sut.todos.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    // MARK: - 할 일 불러오기 테스트
    func test_할일_불러오기_성공() async {
        // Given
        mockRepository.addSampleTodos(count: 3)
        
        // When
        await sut.loadTodos()
        
        // Then
        XCTAssertEqual(sut.todos.count, 3)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_할일_불러오기_실패시_에러메시지() async {
        // Given
        mockRepository.shouldFail = true
        
        // When
        await sut.loadTodos()
        
        // Then
        XCTAssertTrue(sut.todos.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.errorMessage, "할 일 목록을 불러올 수 없습니다")
    }
    
    // MARK: - 할 일 추가 테스트
    func test_할일_추가_성공() async {
        // Given
        sut.newTodoTitle = "새로운 할 일"
        
        // When
        await sut.addTodo()
        
        // Then
        XCTAssertEqual(sut.newTodoTitle, "", "제목이 초기화되어야 함")
        XCTAssertEqual(sut.todos.count, 1)
        XCTAssertEqual(sut.todos.first?.title, "새로운 할 일")
    }
    
    func test_할일_추가_안됨() async {
        // Given
        sut.newTodoTitle = ""
        
        // When
        await sut.addTodo()
        
        // Then
        XCTAssertTrue(sut.todos.isEmpty)
    }
    
    // MARK: - 완료 토글 테스트
    func test_완료토글_성공() async {
        // Given
        mockRepository.addSampleTodos(count: 1)
        await sut.loadTodos()
        let todo = sut.todos.first!
        let initialState = todo.isCompleted
        
        // When
        await sut.toggleComplete(todo: todo)
        
        // Then
        XCTAssertEqual(sut.todos.count, 1)
        XCTAssertNotEqual(sut.todos.first?.isCompleted, initialState)
    }
    
    // MARK: - 필터링 테스트
    func test_필터_전체() async {
        // Given
        mockRepository.addSampleTodos(count: 4)
        await sut.loadTodos()
        
        // When
        sut.filterOption = .all
        
        // Then
        XCTAssertEqual(sut.filteredTodos.count, 4)
    }
    
    func test_필터_진행중() async {
        // Given
        mockRepository.addSampleTodos(count: 4)
        await sut.loadTodos()
        
        // When
        sut.filterOption = .active
        
        // Then
        let activeTodos = sut.filteredTodos
        XCTAssertEqual(activeTodos.count, 2)
        XCTAssertTrue(activeTodos.allSatisfy({ !$0.isCompleted }))
    }
    
    func test_필터_완료() async {
        // Given
        mockRepository.addSampleTodos(count: 4)
        await sut.loadTodos()
        
        // When
        sut.filterOption = .completed
        
        // Then
        let completedTodos = sut.filteredTodos
        XCTAssertEqual(completedTodos.count, 2)
        XCTAssertTrue(completedTodos.allSatisfy({ $0.isCompleted }))
    }
    
    // MARK: - 통계 테스트
    func test_완료개수_계산() async {
        // Given
        mockRepository.addSampleTodos(count: 4)
        await sut.loadTodos()
        
        // When & Then
        XCTAssertEqual(sut.completedCount, 2)
    }
    
    func test_진행중_개수_계산() async {
        // Given
        mockRepository.addSampleTodos(count: 4)
        await sut.loadTodos()
        
        // When & Then
        XCTAssertEqual(sut.activeCount, 2)
    }
    
    // MARK: - 검색 테스트
    func test_검색_필터링() async {
        // Given
        mockRepository.todos = [
            TodoItem(title: "Swift 공부"),
            TodoItem(title: "iOS 개발"),
            TodoItem(title: "운동하기")
        ]
        await sut.loadTodos()
        
        // When
        sut.searchQuery = "Swift"
        
        // Then
        XCTAssertEqual(sut.filteredTodos.count, 1)
        XCTAssertEqual(sut.filteredTodos.first?.title, "Swift 공부")
    }
}
