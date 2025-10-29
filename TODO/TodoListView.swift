//
//  TodoListView.swift
//  TODO
//
//  Created by 오정석 on 29/10/2025.
//

import SwiftUI

// MARK: - TodoList

struct TodoListView: View {
    @StateObject private var viewModel = TodoViewModel()
        
    var body: some View {
        NavigationStack {
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
        } //:NAVSTACK
    }
}

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


#Preview {
    TodoListView()
}
