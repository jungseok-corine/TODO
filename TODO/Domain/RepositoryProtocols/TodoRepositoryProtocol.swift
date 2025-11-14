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


