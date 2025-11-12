//
//  TodoListSnapshotTests.swift
//  TODO
//
//  Created by 오정석 on 11/11/2025.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import TODO

final class TodoListSnapshotTests: XCTestCase {
    var mockRepository: MockTodoRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockTodoRepository()
    }
    
    override func tearDown() {
        mockRepository = nil
        super.tearDown()
    }
    
    private func makeViewModel() -> TodoViewModel {
            let fetchUseCase = FetchTodosUseCase(repository: mockRepository)
            let addUseCase = AddTodoUseCase(repository: mockRepository)
            let toggleUseCase = ToggleTodoUseCase(repository: mockRepository)
            let deleteUseCase = DeleteTodoUseCase(repository: mockRepository)
            
            return TodoViewModel(
                fetchTodosUseCase: fetchUseCase,
                addTodoUseCase: addUseCase,
                toggleTodoUseCase: toggleUseCase,
                deleteTodoUseCase: deleteUseCase
            )
        }
    
    func test_빈_목록_스냅샷() async {
        // Given: 빈 Repository
        let viewModel = makeViewModel()
        await viewModel.loadTodos()
        
        // When: View 생성
        let view = TodoListView_ForTesting(viewModel: viewModel)
        let vc = await UIHostingController(rootView: view)
        
        // Then: 스냅샷 비교
        assertSnapshot(matching: vc, as: .image(on: .iPhone13))
    }
    
    func test_할일_목록_스냅샷() async {
        // Given: 샘플 데이터
        mockRepository.addSampleTodos(count: 3)
        let viewModel = makeViewModel()
        await viewModel.loadTodos()
        
        // When
        let view = TodoListView_ForTesting(viewModel: viewModel)
        let vc = await UIHostingController(rootView: view)
        
        // Then
        assertSnapshot(matching: vc, as: .image(on: .iPhone13))
    }
    
    func test_다크모드_스냅샷() async {
        // Given
        mockRepository.addSampleTodos(count: 3)
        let viewModel = makeViewModel()
        await viewModel.loadTodos()
        
        // When
        let view = TodoListView_ForTesting(viewModel: viewModel)
        let vc = await UIHostingController(rootView: view)
        
        // Then
        assertSnapshot(matching: vc, as: .image(on: .iPhone13, traits: .init(userInterfaceStyle: .dark)))
    }
    
    func test_스냅샷() {
        let view = TodoListView()
        let vc = UIHostingController(rootView: view)
        
        // ✅ 최초: 스냅샷 저장
        assertSnapshot(matching: vc, as: .image(on: .iPhone13), record: true)
    }
}

// MARK: - 테스트용 View

/// 테스트에서 ViewModel을 주입받을 수 있는 View
struct TodoListView_ForTesting: View {
    @State var viewModel: TodoViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // 입력 영역
                HStack {
                    TextField("새로운 할일", text: $viewModel.newTodoTitle)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        Task { await viewModel.addTodo() }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .font(.title2)
                    }
                    .disabled(viewModel.newTodoTitle.isEmpty)
                }
                .padding()
                
                // 필터
                Picker("필터", selection: $viewModel.filterOption) {
                    ForEach(TodoFilter.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // 컨텐츠
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.filteredTodos.isEmpty {
                    VStack {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        Text("할 일이 없습니다")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    List {
                        ForEach(viewModel.filteredTodos, id: \.id) { todo in
                            HStack {
                                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(todo.isCompleted ? .green : .gray)
                                
                                Text(todo.title)
                                    .strikethrough(todo.isCompleted)
                            }
                        }
                    }
                }
            }
            .navigationTitle("TODO")
        }
    }
}
