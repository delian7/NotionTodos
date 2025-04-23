//
//  AddToView.swift
//  NotionTodos
//
//  Created by Delian Petrov on 4/23/25.
//

import SwiftUI

struct AddTodoView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Todo title", text: $title)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.addTodo(name: title)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
