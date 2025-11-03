//
//  TodoRepositoryProtocol.swift
//  TODO
//
//  Created by 오정석 on 3/11/2025.
//

import Foundation


protocol TodoRepositoryProtocol {
    func fetchAll() async throws -> [TodoItem]
    func add(_ item: TodoItem) async throws
    func update(_ item: TodoItem) async throws
    func delete(id: UUID) async throws
}

/// Repository 에러 타입
enum RepositoryError: Error, LocalizedError {
    case notFound
    case saveFailed
    case deleteFailed
    
    var errorDescription: String? {
        switch self {
        case .notFound: return "할 일을 찾을 수 없습니다"
        case .saveFailed: return "저장에 실패했습니다"
        case .deleteFailed: return "삭제에 실패했습니다"
        }
    }
}
