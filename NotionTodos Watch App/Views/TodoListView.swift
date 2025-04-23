import SwiftUI
import Foundation

struct TodoListView: View {
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.todos) { todo in
                    TodoRowView(todo: todo)
                }
            }
            .navigationTitle("Todos")
            .toolbar {
                Button(action: { viewModel.showingAddTodo = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingAddTodo) {
                AddTodoView(viewModel: viewModel)
            }
        }
    }
}
