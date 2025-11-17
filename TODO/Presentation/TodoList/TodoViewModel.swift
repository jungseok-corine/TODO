//
//  TodoViewModel.swift
//  TODO
//
//  Created by 오정석 on 29/10/2025.
//

import SwiftUI
import CoreData

@MainActor
@Observable
class TodoViewModel: NSObject {
    // MARK: -  PROPERTY
    private let repository: CoreDataTodoRepository
    private var fetchedResultsController: NSFetchedResultsController<TodoEntity>?
    
    var todos: [TodoItem] = []
    var errorMessage: String?
    
    var newTodoTitle = ""
    var filterOption: TodoFilter = .all
    var searchQuery = ""
    
//    private var fetchTodosUseCase: FetchTodosUseCase
    private let addTodoUseCase: AddTodoUseCase
    private let toggleTodoUseCase: ToggleTodoUseCase
    private let deleteTodoUseCase: DeleteTodoUseCase
    
    // MARK: -  init
    init(repository: CoreDataTodoRepository,
//         fetchTodosUseCase: FetchTodosUseCase,
         addTodoUseCase: AddTodoUseCase,
         toggleTodoUseCase: ToggleTodoUseCase,
         deleteTodoUseCase: DeleteTodoUseCase
    ) {
        self.repository = repository
//        self.fetchTodosUseCase = fetchTodosUseCase
        self.addTodoUseCase = addTodoUseCase
        self.toggleTodoUseCase = toggleTodoUseCase
        self.deleteTodoUseCase = deleteTodoUseCase
        super.init()
        setupFetchedResultsController()
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
    
//    // 섹션 정보 활용
//    var sections: [TodoSection] {
//        guard let frcSections = fetchedResultsController?.sections else {
//            return []
//        }
//        
//        return frcSections.map { section in
//            let sectionTodos = (section.objects as? [TodoEntity] ?? [])
//                .map { TodoEntityMapper.toDomain($0) }
//            
//            return TodoSection(
//                name: section.name,
//                todos: sectionTodos
//            )
//        }
//    }
    
    var completedCount: Int {
        todos.filter { $0.isCompleted }.count
    }
    
    var activeCount: Int {
        todos.filter { !$0.isCompleted }.count
    }
    
    // MARK: - Setup
        private func setupFetchedResultsController() {
            fetchedResultsController = repository.makeSectionedFetchedResultsController()
            fetchedResultsController?.delegate = self
            
            do {
                try fetchedResultsController?.performFetch()
                updateTodos()
            } catch {
                errorMessage = "데이터 로드 실패: \(error.localizedDescription)"
                print("❌ FRC performFetch 실패: \(error)")
            }
        }
    
    private func updateTodos() {
            guard let objects = fetchedResultsController?.fetchedObjects else {
                todos = []
                return
            }
            todos = objects.map { TodoEntityMapper.toDomain($0) }
        }
    
    // MARK: - Function

//    func loadTodos() async {
//        isLoading = true
//        errorMessage = nil
//        
//        do {
//            todos = try await fetchTodosUseCase.execute()
//        } catch {
//            errorMessage = "할 일 목록을 불러올 수 없습니다"
//            print("❌ 할 일 불러오기 실패: \(error)")
//        }
//        isLoading = false
//    }
//    
    func addTodo() async {
        guard !newTodoTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        do {
            try await addTodoUseCase.execute(title: newTodoTitle)
            newTodoTitle = ""
        } catch {
            errorMessage = "할 일 추가에 실패했습니다"
            print("❌ 할 일 추가 실패: \(error)")
        }
    }
    
    func toggleComplete(todo: TodoItem) async {
        do {
            try await toggleTodoUseCase.execute(todo: todo)
        } catch {
            errorMessage = "상태 변경에 실패했습니다"
            print("❌ 할 일 토글 실패: \(error)")
        }
    }
    
    func deleteTodo(id: UUID) async {
        do {
            try await deleteTodoUseCase.execute(id: id)
        } catch {
            errorMessage = "삭제에 실패했습니다"
            print("❌ 할 일 삭제 실패: \(error)")
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TodoViewModel: NSFetchedResultsControllerDelegate {
    nonisolated func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        Task { @MainActor in
            updateTodos()
        }
    }
    
    var sections: [TodoSection] {
        let grouped = Dictionary(grouping: todos) { todo in
            Calendar.current.startOfDay(for: todo.createdAt)
        }
        
        return grouped.map { date, todos in
            TodoSection(
                date: date,
                title: formatSectionTitle(date),
                todos: todos
                )
        }.sorted { $0.date > $1.date }
    }
    
    private func formatSectionTitle(_ date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "오늘"
        } else  if calendar .isDateInYesterday(date) {
            return "어제"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "M월 d일 (E)"
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: date)
        }
    }
}
