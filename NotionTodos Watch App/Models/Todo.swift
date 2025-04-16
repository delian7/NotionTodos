//
//  Todo.swift
//  NotionTodos Watch App
//
//  Created by Delian Petrov on 4/16/25.
//

import Foundation
struct Todo {
    let id: UUID;
    let title: String;
    var isCompleted: Bool;
    var createdAt: Date;
}
