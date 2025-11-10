////
////  TodoRepository.swift
////  TODO
////
////  Created by 오정석 on 3/11/2025.
////
//
//import Foundation
//import Combine
//
///// TODO 저장소 구현체
///// - Note: 현재는 메모리에만 저장, 나중에 CoreData로 변경 예정
//class TodoRepository: TodoRepositoryProtocol {
//    
//    static let shared = TodoRepository()
//    
//    private init() {}
//    
//    // MARK: - Properties
//    
//    private(set) var todos: [TodoItem] = [] // 나중에 CoreData로 변경
//    
//    func fetchAll() async throws -> [TodoItem] {
//        // 시뮬레이션: 네트워크 지연
//        try await Task.sleep(for: .milliseconds(100))
//        print("📦 Repository: \(todos.count)개 할 일 불러옴")
//        return todos
//    }
//    
//    func add(_ todo: TodoItem) async throws {
//        try await Task.sleep(for: .milliseconds(100))
//        todos.append(todo)
//        print("✅ Repository: '\(todo.title)' 추가됨")
//    }
//    
//    func update(_ todo: TodoItem) async throws {
//        try await Task.sleep(for: .milliseconds(100))
//        
//        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else {
//            throw RepositoryError.notFound
//        }
//        
//        todos[index] = todo
//        print("✏️ Repository: '\(todo.title)' 업데이트됨")
//    }
//    
//    func delete(id: UUID) async throws {
//        try await Task.sleep(for: .milliseconds(100))
//        
//        guard let index = todos.firstIndex(where: { $0.id == id }) else {
//            throw RepositoryError.notFound
//        }
//        
//        let title = todos[index].title
//        todos.remove(at: index)
//        print("🗑️ Repository: '\(title)' 삭제됨")
//    }
//}
