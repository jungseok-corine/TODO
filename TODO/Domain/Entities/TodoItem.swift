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
    var detail: String?
    var isCompleted: Bool = false
    var createdAt: Date
    var updatedAt: Date?
    var priority: Int  // 0: 낮음, 1: 보통, 2: 높음
    
    enum CodingKeys: String, CodingKey {
        case id, title, detail, isCompleted, createdAt, updatedAt, priority
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        detail = try container.decode(String.self, forKey: .detail)
        isCompleted  = try container.decode(Bool.self, forKey: .isCompleted)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        priority = try container.decodeIfPresent(Int.self, forKey: .priority) ?? 1
    }
    
    init(id: UUID = UUID(),
         title: String,
         detail: String? = nil,
         isCompleted: Bool = false,
         createdAt: Date = Date(),
         updatedAt: Date? = nil,
         priority: Int = 1
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.priority = priority
        
    }
}
