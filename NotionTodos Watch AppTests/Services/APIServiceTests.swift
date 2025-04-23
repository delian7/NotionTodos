//
//  APIServiceTest.swift
//  NotionTodos
//
//  Created by Delian Petrov on 4/16/25.
//

import XCTest
@testable import NotionTodos_Watch_App

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        
        // Create mock todo data
        let todo = Todo(id: UUID(), title: "Test Todo", isCompleted: false, createdAt: Date())
        mockData = try JSONEncoder().encode([todo])
        mockResponse = HTTPURLResponse(url: URL(string: "https://api.test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        return (mockData ?? Data(), mockResponse ?? HTTPURLResponse())
    }
}


class APIServiceTests: XCTestCase {
    var apiService: APIService!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        
        // First set the configuration values
        Configuration.apiKey = "test-api-key"
        Configuration.baseURL = "https://api.test.com"
        Configuration.environment = "test"
        
        mockSession = MockURLSession()
        apiService = APIService(session: mockSession)
    }
    
    func testCreateRequest() {
        let request = apiService.createRequest("todos")
        XCTAssertNotNil(request, "Request should not be nil")
        XCTAssertEqual(request?.url?.host, "api.test.com")
        XCTAssertEqual(request?.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(request?.allHTTPHeaderFields?["x-api-key"], Configuration.apiKey)
    }
    
    func testFetchTodos() async throws {        
        let todos = try await apiService.fetchTodos()
        XCTAssertEqual(todos.first?.title, "Test Todo")
    }
    
    func testCreateTodo() async throws {
        let todo = Todo(id: UUID(), title: "Test Todo", isCompleted: false, createdAt: Date())
        let created = try await apiService.createTodo(todo)
        XCTAssertEqual(created.title, todo.title)
    }
    
    func testUpdateTodo() async throws {
        let todo = Todo(id: UUID(), title: "Test Todo", isCompleted: false, createdAt: Date())
        let created = try await apiService.createTodo(todo)
        var updated = created
        updated.isCompleted = true
        
        let result = try await apiService.updateTodo(updated)
        XCTAssertTrue(result.isCompleted)
    }
    
//    func testDeleteTodo() async throws {
//        let todo = Todo(id: UUID(), title: "Test Todo", isCompleted: false, createdAt: Date())
//        let created = try await apiService.createTodo(todo)
//
//        try await apiService.deleteTodo(created)
//        let todos = try await apiService.fetchTodos()
//        XCTAssertFalse(todos.contains(where: { $0.id == created.id }))
//    }
}
