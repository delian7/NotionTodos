//
//  Configuration.swift
//  NotionTodos
//
//  Created by Delian Petrov on 4/16/25.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }

    static var apiKey: String = {
        guard let apiKey: String = try? value(for: "API_KEY") else {
            return "test-api-key" // Default test value
        }
        return apiKey
    }()

    static var baseURL: String = {
        guard let url: String = try? value(for: "BASE_URL") else {
            return "https://api.test.com" // Default test value
        }
        return url
    }()

    static var environment: String = {
        guard let env: String = try? value(for: "ENV") else {
            return "test" // Default test value
        }
        return env
    }()
}
