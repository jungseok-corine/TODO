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
    @State private var viewModel = TodoViewModel()
    @State private var navigationPath = NavigationPath()
        
    // MARK: -  BODY
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                // 입력 영역
                HStack {
                    TextField("새로운 할일", text: $viewModel.newTodoTitle)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        viewModel.addTodo()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                } //:HSTACK
                .padding()
                
                // 통계
                HStack {
                    Label("\(viewModel.activeCount)", systemImage: "circle")
                    Spacer()
                    Label("\(viewModel.completedCount)", systemImage: "checkmark.circle.fill")
                } //:HSTACK
                .padding(.horizontal)
                .font(.subheadline)
                
                // 필터
                Picker("필터", selection: $viewModel.filterOption) {
                    ForEach(TodoViewModel.FilterOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // 리스트
                List {
                    ForEach(viewModel.todos) { todo in
                        TodoRow(todo: todo) {
                            viewModel.toggleComplete(todo: todo)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTodo)
                } //:LIST
            } //:VSTACK
            .navigationTitle("TODO")
            .navigationDestination(for: TodoRoute.self) { route in
                switch route {
                case .detail(let todo):
                    TodoDetailView(todo: todo)
                case .settings:
                    SettingsView()
                case .statistics:
                    StatisticsView()
                }
            }
            .toolbar {
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
        } //:NAVSTACK
        .onOpenURL { url in
            handleDeepLink(url: url)
        }
    }
    
    // MARK: -  FUNCTION
    private func handleDeepLink(url: URL) {
        
        guard url.scheme == "todoapp",
              url.host == "detail",
              let id = url.pathComponents.last,
              let uuid = UUID(uuidString: id),
              let todo = viewModel.todos.first(where: { $0.id == id }) else {
            print("잘못된 Deep Link")
            return
        }
        navigationPath.append(TodoRoute.detail(todo))
    }
}

// MARK: -  PREVIEW
#Preview {
    TodoListView()
}
