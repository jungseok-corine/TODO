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
        HStack(spacing: 12) {
            // 체크박스
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(todo.isCompleted ? .green : .gray)
                    .imageScale(.large)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .strikethrough(todo.isCompleted)
                    .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                
                if let detail = todo.detail, !detail.isEmpty {
                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    PriorityBadge(priority: todo.priority)
                    
                    Text(todo.createdAt, format: .dateTime.month().day().hour())
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            
            Spacer()
        } //:HSTACK
        .padding(.vertical, 4)
    }
}
