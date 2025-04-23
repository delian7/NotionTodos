//
//  TodoViewModel.swift
//  NotionTodos
//
//  Created by Delian Petrov on 4/23/25.
//

import SwiftUI
class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    @Published var showingAddTodo = false
    private let apiService = APIService()
    
    init() {
        Task { await fetchTodos() }
    }
    
    @MainActor
    func fetchTodos() async {
        do {
            todos = try await apiService.fetchTodos()
        } catch {
            // Handle error
        }
    }
    
    @MainActor
    func addTodo(name: String) {
        let todo = Todo(id: UUID(), name: name, isCompleted: false, date: String())
        Task {
            do {
                let createdTodo = try await apiService.createTodo(todo)
                todos.insert(createdTodo, at: 0)
            } catch {
                print("Error adding todo: \(error)")
                // Handle error
            }
        }
    }
    
    func toggleTodo(_ todo: Todo) {
        var updatedTodo = todo
        updatedTodo.isCompleted.toggle()
        Task {
            do {
                try await apiService.updateTodo(updatedTodo)
                await fetchTodos()
            } catch {
                // Handle error
            }
        }
    }
    
//    func deleteTodo(_ todo: Todo) {
//        Task {
//            do {
//                try await apiService.deleteTodo(todo)
//                await fetchTodos()
//            } catch {
//                // Handle error
//            }
//        }
//    }
}
