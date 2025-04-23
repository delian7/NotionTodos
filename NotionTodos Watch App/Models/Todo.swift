//
//  Todo.swift
//  NotionTodos Watch App
//
//  Created by Delian Petrov on 4/16/25.
//

import Foundation

//struct Todo: Codable, Identifiable {
//    let id: UUID;
//    let name: String;
//    var isCompleted: Bool
//    var date: Date;
//}


struct Todo: Codable, Identifiable {
    let id: UUID
    let name: String
    var isCompleted: Bool
    var date: Date
    
//    enum CodingKeys: String, CodingKey {
//        case id, name, isCompleted, date
//    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try UUID(uuidString: container.decode(String.self, forKey: .id)) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
//        url = try container.decode(String.self, forKey: .url)
        
        let dateString = try container.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.date(from: dateString) ?? Date()
    }
    
    
    init(id: UUID = UUID(), name: String, isCompleted: Bool = false, date: String) {
        self.id = id
        self.name = name
        self.isCompleted = isCompleted
        
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.date(from: dateString) ?? Date()

//        self.url = url
    }
}
