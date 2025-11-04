//
//  TodoItem.swift
//  TODO
//
//  Created by 오정석 on 29/10/2025.
//

import Foundation

// MARK: - TodoItem

struct TodoItem: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool = false
    var createdAt: Date
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
