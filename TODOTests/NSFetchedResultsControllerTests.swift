//
//  NSFetchedResultsControllerTests.swift
//  TODOTests
//
//  Created by 오정석 on 17/11/2025.
//

import XCTest
import CoreData
@testable import TODO

final class NSFetchedResultsControllerTests: XCTestCase {
    var sut: CoreDataTodoRepository!
    var testStack: CoreDataTestStack!
    var frc: NSFetchedResultsController<TodoEntity>!
    
    override func setUp() {
        super.setUp()
        testStack = CoreDataTestStack.shared
        testStack.reset()
        sut = CoreDataTodoRepository(context: testStack.context)
        frc = sut.makeFetchedResultsController()
    }
    
    override func tearDown() {
        frc = nil
        sut = nil
        testStack.reset()
        super.tearDown()
    }
    
    func test_FRC_초기화_성공() throws {
        XCTAssertNotNil(frc, "FRC가 생성되어야 함")
        
        try frc.performFetch()
        
        XCTAssertEqual(frc.fetchedObjects?.count, 0, "초기에는 0개")
    }
    
    func test_FRC_데이터_추가시_자동_업데이트() async throws {
        // Given
        try frc.performFetch()
        let initialCount = frc.fetchedObjects?.count ?? 0
        
        // When
        let todo = TodoItem(title: "Test")
        try await sut.addTodo(todo)
        
        // Then
        XCTAssertEqual(
            frc.fetchedObjects?.count,
            initialCount + 1,
            "Todo 추가 후 FRC가 자동 업데이트되어야 함"
        )
    }
    
    func test_섹션_그룹핑_정상_동작() async throws {
        // Given
        let sectionedFRC = sut.makeSectionedFetchedResultsController()
        try sectionedFRC.performFetch()
        
        // 오늘 2개, 어제 1개 추가
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        try await sut.addTodo(TodoItem(title: "오늘 1", createdAt: today))
        try await sut.addTodo(TodoItem(title: "오늘 2", createdAt: today))
        try await sut.addTodo(TodoItem(title: "어제", createdAt: yesterday))
        
        // Then
        XCTAssertEqual(sectionedFRC.sections?.count, 2, "2개 섹션")
        XCTAssertEqual(sectionedFRC.sections?[0].numberOfObjects, 2, "오늘 2개")
        XCTAssertEqual(sectionedFRC.sections?[1].numberOfObjects, 1, "어제 1개")
    }
}
