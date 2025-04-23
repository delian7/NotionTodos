import Foundation

class Configuration {
    private static func loadPlist() -> [String: Any]? {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
              let dictionary = plist as? [String: Any] else {
            return nil
        }
        return dictionary
    }
    
    static var apiKey: String {
        return loadPlist()?["API_KEY"] as? String ?? ""
    }
    
    static var baseURL: String {
        return loadPlist()?["BASE_URL"] as? String ?? ""
    }
    
    static var environment: String {
        return loadPlist()?["ENVIRONMENT"] as? String ?? "test"
    }
}
