//
//  MockTodoRepository.swift
//  TODOTests
//
//  Created by 오정석 on 10/11/2025.
//

import Foundation
import Combine
//import CoreData
@testable import TODO

class MockTodoRepository: TodoRepositoryProtocol {
    
    // 테스트용 데이터
    var todos: [TodoItem] = []
    
    // 에러 시뮬레이션용
    var shouldFail = false // 에러 테스트용
    var errorToThrow: Error = RepositoryError.notFound
    
    func fetchAll() -> AnyPublisher<[TodoItem], any Error> {
        if shouldFail {
            return Fail(error: errorToThrow)
                .eraseToAnyPublisher()
        }
        
        return Just(todos)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func add(_ item: TodoItem) -> AnyPublisher<Void, any Error> {
        
        if shouldFail {
            return Fail(error: errorToThrow)
                .eraseToAnyPublisher()
        }
        
        todos.append(item)
        
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func update(_ item: TodoItem) -> AnyPublisher<Void, any Error> {
        
        
        if self.shouldFail {
            return Fail(error: errorToThrow)
                .eraseToAnyPublisher()
        }
        
        // 배열에서 해당 Id를 가진 항목 찾기
        guard let index = self.todos.firstIndex(where: { $0.id == item.id }) else {
            return Fail(error: errorToThrow)
                .eraseToAnyPublisher()
        }
        
        // 배열에서 해당 인덱스의 항목 업데이트
        todos[index] = item
        
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func delete(id: UUID) -> AnyPublisher<Void, any Error> {
        if shouldFail {
            return Fail(error: errorToThrow)
                .eraseToAnyPublisher()
        }
        
        guard let index = todos.firstIndex(where: { $0.id == id }) else {
            return Fail(error: errorToThrow)
                .eraseToAnyPublisher()
        }
        
        self.todos.remove(at: index)
        
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

extension MockTodoRepository {
    /// 테스트 데이터 초기화
    func reset() {
        todos = []
        shouldFail = false
    }
    
    /// 샘플 할 일 추가
    func addSampleTodos(count: Int = 3) {
        for i in 1...count {
            let todo = TodoItem(
                title: "테스트 할 일 \(i)",
                isCompleted: i % 2 == 0
            )
            todos.append(todo)
        }
    }
}
