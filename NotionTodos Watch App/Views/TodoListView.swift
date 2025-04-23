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
            .refreshable {
                await viewModel.fetchTodos()
            }
            .sheet(isPresented: $viewModel.showingAddTodo) {
                AddTodoView(viewModel: viewModel)
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: { viewModel.showingAddTodo = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 14))
                    }
                }
            }
        }
    }
}

#Preview {
    TodoListView()
}
