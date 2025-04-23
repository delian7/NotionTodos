//
//  APIService.swift
//  NotionTodos
//
//  Created by Delian Petrov on 4/16/25.
//

import Foundation

enum APIError: Error {
    case invalidRequest
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError(Error)
}

class APIService {
    let baseURL = Configuration.baseURL
    let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    private var headers: [String: String] {
        [
            "x-api-key": Configuration.apiKey,
            "Content-Type": "application/json"
        ]
    }
    
    func createRequest(_ endpoint: String) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        return request
    }
    
    func fetchTodos() async throws -> [Todo] {
        guard let request = createRequest("todos") else {
            throw APIError.invalidRequest
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let todos = try JSONDecoder().decode([Todo].self, from: data)
            return todos
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    func createTodo(_ todo: Todo) async throws -> Todo {
        guard var request = createRequest("todos") else {
            throw APIError.invalidRequest
        }
        
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(todo)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
        
        return todo
    }
    
    func updateTodo(_ todo: Todo) async throws -> Todo {
        guard var request = createRequest("todos/\(todo.id)") else {
            throw APIError.invalidRequest
        }
        
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(todo)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let todos = try JSONDecoder().decode([Todo].self, from: data)
            guard let updatedTodo = todos.first else {
                    throw APIError.invalidResponse
            }
            return updatedTodo
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
