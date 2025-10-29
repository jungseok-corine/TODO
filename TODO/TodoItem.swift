//
//  TodoItem.swift
//  TODO
//
//  Created by 오정석 on 29/10/2025.
//

import Foundation

// MARK: - TodoItem

struct TodoItem: Identifiable {
    let id: String = UUID().uuidString
    var title: String
    var isCompleted: Bool = false
    var createdAt = Date()
}
