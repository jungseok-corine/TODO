//
//  TodoSection.swift
//  TODO
//
//  Created by 오정석 on 17/11/2025.
//

import Foundation

struct TodoSection: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let todos: [TodoItem]
}
