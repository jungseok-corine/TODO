//
//  TodoViewModel.swift
//  TODO
//
//  Created by 오정석 on 29/10/2025.
//

import SwiftUI
import Observation

// MARK: - TodoViewModel

@Observable
class TodoViewModel {
    // MARK: -  PROPERTY
    var todos: [TodoItem] = []
    var newTodoTitle = ""
    var isLoading = false
    var filterOption: TodoFilter = .all
    var searchQuery = ""
    var errorMessage: String?
    
    private let fetchTodosUseCase: FetchTodosUseCase
    private let addTodoUseCase: AddTodoUseCase
    private let toggleTodoUseCase: ToggleTodoUseCase
    private let deleteTodoUseCase: DeleteTodoUseCase
    
    // MARK: -  init
    init(fetchTodosUseCase: FetchTodosUseCase,
         addTodoUseCase: AddTodoUseCase,
         toggleTodoUseCase: ToggleTodoUseCase,
         deleteTodoUseCase: DeleteTodoUseCase) {
        self.fetchTodosUseCase = fetchTodosUseCase
        self.addTodoUseCase = addTodoUseCase
        self.toggleTodoUseCase = toggleTodoUseCase
        self.deleteTodoUseCase = deleteTodoUseCase
    }
    
    // MARK: - Computed Properties
    var filteredTodos: [TodoItem] {
        let filtered = todos.filter { todo in
            if !searchQuery.isEmpty {
                return todo.title.localizedCaseInsensitiveContains(searchQuery)
            }
            return true
        }
        
        switch filterOption {
        case .all:
            return filtered
        case .active:
            return filtered.filter { !$0.isCompleted }
        case .completed:
            return filtered.filter { $0.isCompleted }
        }
    }
    var completedCount: Int {
        todos.filter { $0.isCompleted }.count
    }
    
    var activeCount: Int {
        todos.filter { !$0.isCompleted }.count
    }
    
    // MARK: - Function
    func loadTodos() async {
        isLoading = true
        errorMessage = nil
        
        do {
            todos = try await fetchTodosUseCase.execute()
        } catch {
            errorMessage = "할 일 목록을 불러올 수 없습니다"
            print("❌ 할 일 불러오기 실패: \(error)")
        }
        isLoading = false
    }
    
    func addTodo() async {
        guard !newTodoTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        do {
            try await addTodoUseCase.execute(title: newTodoTitle)
            newTodoTitle = ""
            await loadTodos()
        } catch {
            errorMessage = "할 일 추가에 실패했습니다"
            print("❌ 할 일 추가 실패: \(error)")
        }
    }
    
    func toggleComplete(todo: TodoItem) async {
        do {
            try await toggleTodoUseCase.execute(todo: todo)
            await loadTodos()
        } catch {
            errorMessage = "상태 변경에 실패했습니다"
            print("❌ 할 일 토글 실패: \(error)")
        }
    }
    
    func deleteTodo(id: UUID) async {
        do {
            try await deleteTodoUseCase.execute(id: id)
            await loadTodos()
        } catch {
            errorMessage = "삭제에 실패했습니다"
            print("❌ 할 일 삭제 실패: \(error)")
        }
    }
}

