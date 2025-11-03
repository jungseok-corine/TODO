//
//  TodoDetailView.swift
//  TODO
//
//  Created by 오정석 on 31/10/2025.
//

import SwiftUI

struct TodoDetailView: View {
    let todo: TodoItem
    @Environment(\.dismiss) private var dismiss
    
    @State private var editedTitle: String
    @State private var notes: String = ""
    @State private var priority: Priority = .medium
    @State private var dueDate: Date = Date()
    @State private var isEditing = false
    
    enum Priority: String, CaseIterable {
        case low = "낮음"
        case medium = "보통"
        case high = "높음"
    }
    
    init(todo: TodoItem) {
        self.todo = todo
        _editedTitle = State(initialValue: todo.title)
    }
    
    var body: some View {
        Form {
            Section("기본 정보") {
                if isEditing {
                    TextField("제목", text: $editedTitle)
                } else {
                    Text(todo.title)
                        .font(.headline)
                }
                
                HStack {
                    Text("상태")
                    Spacer()
                    Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(todo.isCompleted ? .green : .gray)
                } //: HStack
                
                HStack {
                    Text("생성일")
                    Spacer()
                    Text(todo.createdAt, style: .date)
                        .foregroundStyle(.secondary)
                } //:HSTACK
            } //:SECTION
            
            Section("세부 사항") {
                Picker("우선순위", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.rawValue).tag(priority)
                    }
                } //:SECTION
                
                DatePicker("마감일", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                
                if isEditing {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                } else {
                    Text(notes.isEmpty ? "메모 없음" : notes)
                        .foregroundStyle(notes.isEmpty ? .secondary : .primary)
                }
            }
            
            Section {
                Button(role: .destructive) {
                    // TODO: 삭제 기능
                    dismiss()
                } label: {
                    Text("삭제")
                        .frame(maxWidth: .infinity)
                }
            } //:SECTION
        } //:FORM
        .navigationTitle("상세 정보")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "완료" : "편집") {
                    isEditing.toggle()
                }
            }
        }
    }
}

#Preview {
    TodoDetailView(todo: TodoItem(title: "할일"))
}
