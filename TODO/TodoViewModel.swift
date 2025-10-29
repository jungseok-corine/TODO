//
//  TodoViewModel.swift
//  TODO
//
//  Created by 오정석 on 29/10/2025.
//

import Combine
import SwiftUI

// MARK: - TodoViewModel

class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var newTodoTitle = ""
    @Published var filterOption: FilterOption = .all
    
    enum FilterOption: String, CaseIterable {
        case all = "전체"
        case active = "진행중"
        case completed = "완료"
    }
    
    var filteredTodos: [TodoItem] {
        switch filterOption {
        case .all:
            return todos
        case .active:
            return todos.filter { !$0.isCompleted }
        case .completed:
            return todos.filter { $0.isCompleted }
        }
    }
    
    var completedCount: Int {
        todos.filter { $0.isCompleted }.count
    }
    
    var activeCount: Int {
        todos.filter { !$0.isCompleted }.count
    }
    
    func addTodo() {
        guard !newTodoTitle.isEmpty else { return }
        
        let newTodo = TodoItem(title: newTodoTitle)
        todos.append(newTodo)
        newTodoTitle = ""
    }
    
    func toggleComplete(todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id}) {
            todos[index].isCompleted.toggle()
        }
    }
    
    func deleteTodo(at offsets: IndexSet) {
            todos.remove(atOffsets: offsets)
    }
}

