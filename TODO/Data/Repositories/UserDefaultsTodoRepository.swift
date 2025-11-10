////
////  UserDefaultsTodoRepository.swift
////  TODO
////
////  Created by 오정석 on 4/11/2025.
////
//
//import Foundation
//
///// UserDefaults를 사용하는 할 일 저장소
/////  - Note: JSON 인코딩/디코딩으로 영구 저장
//class UserDefaultsTodoRepository: TodoRepositoryProtocol {
//    // MARK: - Properties
//    static let shared = UserDefaultsTodoRepository()
//    
//    private let todosKey = "todos"
//    
//    private let userDefaults = UserDefaults.standard
//    
//    private let encoder = JSONEncoder()
//    
//    private let decoder = JSONDecoder()
//    
//    private init() {
//        encoder.dateEncodingStrategy = .iso8601
//        decoder.dateDecodingStrategy = .iso8601
//        
//        print("📱 UserDefaultsTodoRepository 초기화")
//    }
//    
//    // MARK: - TodoRepositoryProtocol 구현
//    
//    func fetchAll() async throws -> [TodoItem] {
//        try await Task.sleep(for: .milliseconds(200))
//        
//        guard let data = userDefaults.data(forKey: todosKey) else {
//            print("💾 UserDefaults: 저장된 데이터 없음")
//            return []
//        }
//        
//        do {
//            // JSON 디코딩
//            let todos = try decoder.decode([TodoItem].self, from: data)
//            print("💾 UserDefaults: \(todos.count)개 할 일 불러옴")
//            return todos
//        } catch {
//            print("❌ 디코딩 실패: \(error)")
//            throw RepositoryError.decodeFailed
//        }
//    }
//    
//    func add(_ item: TodoItem) async throws {
//        try await Task.sleep(for: .milliseconds(100))
//        
//        // 1. 기존 데이터 불러오기
//        var todos = try await fetchAll()
//        
//        // 2. 새 항목 추가
//        todos.append(item)
//        
//        // 3. 저장
//        try await saveTodos(todos)
//        
//        print("✅ UserDefaults: '\(item.title)' 추가됨")
//    }
//    
//    func update(_ item: TodoItem) async throws {
//        try await Task.sleep(for: .milliseconds(100))
//        
//        // 1. 기존 데이터 불러오기
//        var todos = try await fetchAll()
//        
//        // 2. 해당 항목 찾기
//        guard let index = todos.firstIndex(where: { $0.id == item.id }) else {
//            throw RepositoryError.notFound
//        }
//        
//        // 3. 업데이트
//        todos[index] = item
//        
//        // 4. 저장
//        try await saveTodos(todos)
//        
//        print("✏️ UserDefaults: '\(item.title)' 업데이트됨")
//    }
//    
//    func delete(id: UUID) async throws {
//        try await Task.sleep(for: .milliseconds(100))
//        
//        // 1. 기존 데이터 불러오기
//        var todos = try await fetchAll()
//        
//        // 2. 해당 항목 찾기
//        guard let index = todos.firstIndex(where: { $0.id == id }) else {
//            throw RepositoryError.notFound
//        }
//        
//        let title = todos[index].title
//        
//        // 3. 삭제
//        todos.remove(at: index)
//        
//        // 4. 저장
//        try await saveTodos(todos)
//        
//        print("🗑️ UserDefaults: '\(title)' 삭제됨")
//    }
//    
//    // MARK: - Private Methods
//    
//    /// 할 일 목록을 UserDefaults에 저장
//    private func saveTodos(_ todos: [TodoItem]) async throws {
//        do {
//            // JSON 인코딩
//            let data = try encoder.encode(todos)
//            
//            // UserDefaults에 저장
//            userDefaults.set(data, forKey: todosKey)
//            
//            print("💾 UserDefaults: \(todos.count)개 저장 완료")
//        } catch {
//            print("❌ 인코딩 실패: \(error)")
//            throw RepositoryError.saveFailed
//        }
//    }
//    
//    /// 모든 데이터 삭제 (디버깅용)
//    func clearAll() {
//        userDefaults.removeObject(forKey: todosKey)
//        print("🗑️ UserDefaults: 모든 데이터 삭제")
//    }
//}
