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
    var filterOption: FilterOption = .all
    var errorMessage: String?
    
    private let fetchTodosUseCase: FetchTodosUseCase
    private let addTodoUseCase: AddTodoUseCase
    private let toggleTodoUseCase: ToggleTodoUseCase
    private let deleteTodoUseCase: DeleteTodoUseCase
    
    // MARK: - FilterOption
    enum FilterOption: String, CaseIterable {
        case all = "전체"
        case active = "진행중"
        case completed = "완료"
    }
    
    // MARK: - Computed Properties
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
    
    // MARK: - Function
    func loadTodos() async {
        isLoading = true
        errorMessage = nil
        
        do {
            todos = try await fetchTodosUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
            print("❌ 할 일 불러오기 실패: \(error)")
        }
        isLoading = false
    }
    
    func addTodo() async {
        guard !newTodoTitle.isEmpty else { return }
        
        do {
            try await addTodoUseCase.execute(title: newTodoTitle)
            newTodoTitle = ""
            await loadTodos()
        } catch {
            errorMessage = error.localizedDescription
            print("❌ 할 일 추가 실패: \(error)")
        }
    }
    
    func toggleComplete(todo: TodoItem) async {
        do {
            try await toggleTodoUseCase.execute(todo: todo)
            await loadTodos()
        } catch {
            errorMessage = error.localizedDescription
            print("❌ 할 일 토글 실패: \(error)")
        }
    }
    
    func deleteTodo(at offsets: IndexSet) async {
        for index in offsets {
            let todo = filteredTodos[index]
            do {
                try await deleteTodoUseCase.execute(id: todo.id)
            } catch {
                errorMessage = error.localizedDescription
                print("❌ 할 일 삭제 실패: \(error)")
            }
        }
        await loadTodos()
    }
}

