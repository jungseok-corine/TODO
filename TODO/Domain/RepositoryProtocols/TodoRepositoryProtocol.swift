//
//  TodoRepositoryProtocol.swift
//  TODO
//
//  Created by 오정석 on 3/11/2025.
//

import Foundation

protocol TodoRepositoryProtocol {
    func fetchTodos() async throws -> [TodoItem]
    func addTodo(_ item: TodoItem) async throws
    func updateTodo(_ item: TodoItem) async throws
    func deleteTodo(id: UUID) async throws
}


