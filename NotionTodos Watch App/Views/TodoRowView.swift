//
//  TodoRowView.swift
//  NotionTodos
//
//  Created by Delian Petrov on 4/23/25.
//
import SwiftUI

struct TodoRowView: View {
    let todo: Todo
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        HStack {
            Text(todo.name)
                .strikethrough(todo.isCompleted)
            Spacer()
            Button(action: { viewModel.toggleTodo(todo) }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
//                viewModel.deleteTodo(todo)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
