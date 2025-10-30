//
//  TodoRow.swift
//  TODO
//
//  Created by 오정석 on 30/10/2025.
//

import SwiftUI

// MARK: - TodoRow

struct TodoRow: View {
    let todo: TodoItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(todo.isCompleted ? .green : .gray)
                .onTapGesture {
                    onToggle()
                }
            
            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .gray : .primary)
        } //:HSTACK
    }
}
