//
//  TodoListUITests.swift
//  TODO
//
//  Created by 오정석 on 11/11/2025.
//

import XCTest

final class TodoListUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Tests
    func test_앱_실행_성공() {
        // Given: 앱이 실행됨
        
        // Then: 네비게이션 타이틀 확인
        XCTAssertTrue(app.navigationBars["TODO"].exists)
    }
    
    func test_할일_추가_플로우() {
        // Given: 초기 화면
        let textField = app.textFields["새로운 할일"]
        let addButton = app.buttons.matching(identifier: "plus.circle.fill").firstMatch
        
        // When: 할 일 입력 및 추가
        textField.tap()
        textField.typeText("UI 테스트 할일")
        addButton.tap()
        
        // Then: 리스트에 추가됨
        let todoCell = app.staticTexts["UI 테스트 할일"]
        XCTAssertTrue(todoCell.exists)
    }
    
    func test_필터_전환() {
        // Given: 할 일이 있는 상태
        addTodo(title: "테스트 1")
        
        // When: 필터 변경
        let filterPicker = app.segmentedControls.firstMatch
        filterPicker.buttons["진행중"].tap()
        
        // Then: 필터가 적용됨
        XCTAssertTrue(filterPicker.buttons["진행중"].isSelected)
    }
    
    func test_할일_완료_토글() {
        // Given: 할 일 추가
        addTodo(title: "완료할 일")
        
        // When: 체크 아이콘 탭
        let checkIcon = app.images["circle"].firstMatch
        checkIcon.tap()
        
        // Then: 완료 아이콘으로 변경
        let completedIcon = app.images["checkmark.circle.fill"].firstMatch
        XCTAssertTrue(completedIcon.exists)
    }
    
    func test_할일_삭제() {
        // Given: 할 일 추가
        addTodo(title: "삭제할 일")
        let todoCell = app.staticTexts["삭제할 일"]
        
        // When: 스와이프 삭제
        todoCell.swipeLeft()
        app.buttons["Delete"].tap()
        
        // Then: 삭제됨
        XCTAssertFalse(todoCell.exists)
    }
    
    // MARK: - Helper
    private func addTodo(title: String) {
        let textField = app.textFields["새로운 할일"]
        let addButton = app.buttons.matching(identifier: "plus.circle.fill").firstMatch
        
        textField.tap()
        textField.typeText(title)
        addButton.tap()
    }
    
    // MARK: - 복잡한 시나리오 테스트
    func test_검색_필터_조합() {
        // Given: 여러 할 일 추가
        addTodo(title: "iOS 공부")
        addTodo(title: "운동하기")
        addTodo(title: "iOS 개발")
        
        // 첫 번째 완료 처리
        app.images["circle"].firstMatch.tap()
        
        // When: 검색
        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("iOS")
        
        // Then: 필터링된 결과 확인
        XCTAssertTrue(app.staticTexts["iOS 공부"].exists)
        XCTAssertTrue(app.staticTexts["iOS 개발"].exists)
        XCTAssertFalse(app.staticTexts["운동하기"].exists)
        
        // When: 완료 필터 적용
        app.segmentedControls.firstMatch.buttons["완료"].tap()
        
        // Then: 완료된 할 일만 표시
        XCTAssertTrue(app.staticTexts["iOS 공부"].exists)
        XCTAssertFalse(app.staticTexts["iOS 개발"].exists)
    }
    
    func test_빈_입력_추가_방지() {
        // Given: 빈 텍스트 필드
        let textField = app.textFields["새로운 할일"]
        let addButton = app.buttons["addButton"]
        
        // When: 빈 상태로 추가 시도
        textField.tap()
        addButton.tap()
        
        // Then: 버튼이 비활성화되어야 함
        XCTAssertFalse(addButton.isEnabled)
    }
    
    func test_네비게이션_플로우() {
        // Given: 할 일 추가
        addTodo(title: "테스트")
        
        // When: 설정 탭으로 이동
        app.tabBars.buttons["Settings"].tap()
        
        // Then: 설정 화면 표시
        XCTAssertTrue(app.navigationBars["설정"].exists)
        
        // When: 다시 TODO 탭으로
        app.tabBars.buttons["TODO"].tap()
        
        // Then: TODO 화면 복귀
        XCTAssertTrue(app.navigationBars["TODO"].exists)
    }
    
    // MARK: - 대기 및 동기화
    func test_비동기_로딩() {
        // Given: 앱 실행
        app.launch()
        
        // When: 데이터 로딩 대기 (최대 5초)
        let loadingIndicator = app.activityIndicators.firstMatch
        let exists = loadingIndicator.waitForExistence(timeout: 5)
        
        // Then: 로딩 완료
        XCTAssertTrue(exists)
        
        // 로딩이 사라질 때까지 대기
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: loadingIndicator)
        wait(for: [expectation], timeout: 10)
    }
    
    func test_에러_메시지_표기() {
        // Given: 에러 상황 시뮬레이션
        // (LaunchArgument로 설정)
        app.launchArguments = ["-uiTesting", "-mockError"]
        app.launch()
        
        // When: 데이터 로드 시도
        // ...
        
        // Then: 에러 메시지 표시
        let errorMessage = app.staticTexts["할 일 목록을 불러올 수 없습니다"]
        XCTAssertTrue(errorMessage.waitForExistence(timeout: 3))
    }
}
