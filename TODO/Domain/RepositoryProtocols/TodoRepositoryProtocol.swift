//
//  TodoRepositoryProtocol.swift
//  TODO
//
//  Created by 오정석 on 3/11/2025.
//

import Combine
import Foundation


protocol TodoRepositoryProtocol {
    func fetchAll() -> AnyPublisher<[TodoItem], Error>
    func add(_ item: TodoItem) -> AnyPublisher<Void, Error>
    func update(_ item: TodoItem) -> AnyPublisher<Void, Error>
    func delete(id: UUID) -> AnyPublisher<Void, Error>
}


