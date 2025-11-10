//
//  TodoListView.swift
//  TODO
//
//  Created by 오정석 on 29/10/2025.
//

import SwiftUI

// 네비게이션 경로 정의

enum TodoRoute: Hashable {
    case detail(TodoItem)
    case settings
    case statistics
}

// MARK: - TodoList
struct TodoListView: View {
    
    // MARK: -  PROPERTY
    @State private var viewModel: TodoViewModel = DIContainer.shared.makeTodoViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @State private var navigationPath = NavigationPath()
    
    // ⭐️ Alert 표시 상태 추가
    @State private var showErrorAlert = false
    
    // MARK: -  BODY
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                // 검색바
                searchSection
                // 필터
                filterSection
                // 입력 영역
                inputSection
                // 에러 메시지
                errorSection
                // 컨텐츠 영역
                contentSection
            }
            .navigationTitle("TODO")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: TodoRoute.self) { route in
                destination(for: route)
            }
            .toolbar {
                toolbarContent
            }
            .task {
                await viewModel.loadTodos()
            }
            .refreshable {
                await viewModel.loadTodos()
            }
            // ⭐️ Error Alert 추가
            .alert("오류", isPresented: $showErrorAlert) {
                Button("확인", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onChange(of: viewModel.errorMessage) { oldValue, newValue in
                if newValue != nil {
                    showErrorAlert = true
                }
            }
        } //:NAVSTACK
        .onOpenURL { url in
            handleDeepLink(url: url)
        }
    }
    
    // MARK: -  FUNCTION
    private var searchSection: some View {
        SearchBar(text: $viewModel.searchQuery)
    }
    
    private var filterSection: some View {
        // 필터
        Picker("필터", selection: $viewModel.filterOption) {
            ForEach(TodoFilter.allCases, id: \.self) { option in
                Text(option.rawValue).tag(option)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    private var inputSection: some View {
        HStack {
            TextField("새로운 할일", text: $viewModel.newTodoTitle)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.done)
                .onSubmit {
                    Task { await viewModel.addTodo() }
                }
            
            Button {
                Task { await viewModel.addTodo() }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .imageScale(.large)
                    .font(.title2)
            }
            .disabled(viewModel.newTodoTitle.isEmpty)
        } //:HSTACK
        .padding()
    }
    
    @ViewBuilder
    private var errorSection: some View {
        // 에러 메시지
        if let error = viewModel.errorMessage {
            Text(error)
                .font(.caption)
                .foregroundStyle(.red)
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            Spacer()
            ProgressView()
            Spacer()
        } else if viewModel.filteredTodos.isEmpty {
            Spacer()
            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 60))
                    .foregroundStyle(.secondary)
                
                Text("할 일이 없습니다")
                    .foregroundStyle(.secondary)
            } //:VSTACK
            Spacer()
        } else {
            List {
                ForEach(viewModel.filteredTodos, id: \.id) { todo in
                    TodoRow(todo: todo) {
                        Task { await viewModel.toggleComplete(todo: todo)}
                    }
                } //:LOOP
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let todo = viewModel.filteredTodos[index]
                        Task { await viewModel.deleteTodo(id: todo.id)}
                    }
                }
            } //:LIST
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button {
                    navigationPath.append(TodoRoute.settings)
                } label: {
                    Label("설정", systemImage: "gear")
                }
                
                Button {
                    navigationPath.append(TodoRoute.statistics)
                } label: {
                    Label("통계", systemImage: "chart.bar")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
    
    private func handleDeepLink(url: URL) {
        guard url.scheme == "todoapp",
              url.host == "detail",
              let id = url.pathComponents.last,
              let uuid = UUID(uuidString: id),
              let todo = viewModel.todos.first(where: { $0.id == uuid }) else {
            print("잘못된 Deep Link")
            return
        }
        navigationPath.append(TodoRoute.detail(todo))
    }
    
    @ViewBuilder
    private func destination(for route: TodoRoute) -> some View {
        switch route {
        case .detail(let todo):
            TodoDetailView(todo: todo)
        case .settings:
            SettingsView()
        case .statistics:
            StatisticsView()
        }
    }
}

// MARK: -  PREVIEW
#Preview {
    TodoListView()
}
