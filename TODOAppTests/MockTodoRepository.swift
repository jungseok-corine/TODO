//
//  MockTodoRepository.swift
//  TODOTests
//
//  Created by 오정석 on 10/11/2025.
//

import Foundation
import Combine
import CoreData

class MockTodoRepository: TodoRepositoryProtocol {
    var todos: [TodoItem] = []
    var shouldFail = false // 에러 테스트용
    
    func fetchAll() -> AnyPublisher<[TodoItem], any Error> {
        Future{ [weak self] promise in
            guard let self = self  else {
                promise(.failure(RepositoryError.notFound))
                return
            }
            
            if self.shouldFail {
                promise(.failure(RepositoryError.notFound))
                return
            }
            promise(.success(self.todos))
        }
        .eraseToAnyPublisher()
    }
    
    func add(_ item: TodoItem) -> AnyPublisher<Void, any Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(RepositoryError.notFound))
                return
            }
            
            if self.shouldFail {
                promise(.failure(RepositoryError.notFound))
                return
            }
            todos.append(item)
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func update(_ item: TodoItem) -> AnyPublisher<Void, any Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(RepositoryError.notFound))
                return
            }
            
            if self.shouldFail {
                promise(.failure(RepositoryError.notFound))
                return
            }
            
            // 배열에서 해당 Id를 가진 항목 찾기
            guard let index = self.todos.firstIndex(where: { $0.id == item.id }) else {
                promise(.failure(RepositoryError.notFound))
                return
            }
            
            // 배열에서 해당 인덱스의 항목 업데이트
            self.todos[index] = item
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func delete(id: UUID) -> AnyPublisher<Void, any Error> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(RepositoryError.notFound))
                return
            }
            
            if self.shouldFail {
                promise(.failure(RepositoryError.deleteFailed))
                return
            }
            
            guard let index = self.todos.firstIndex(where: { $0.id == id }) else {
                promise(.failure(RepositoryError.notFound))
                return
            }
            
            self.todos.remove(at: index)
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}
