import Foundation

enum ParserError: Error {
    case noFile
}

final class Parser {
    static let shared = Parser()
    
    private var rebuses: [Rebus] = []
    
    private init() {
        getRebuses()
    }
    
    private lazy var decoder = JSONDecoder()
    
    func getRebus(at index: Int) -> Rebus? {
        guard rebuses.indices.contains(index) else { return nil }
        return rebuses[index]
    }
    
    private func getRebuses() {
        do {
            let jsonData = try getJsonData()
            let parsedData = try parseData(jsonData)
            rebuses = parsedData
        } catch {
            print("--- error: \(error)")
        }
    }
    
    private func getJsonData() throws -> Data {
        guard let fileURL = Bundle.main.url(forResource: "rebuses", withExtension: "json") else {
            throw ParserError.noFile
        }
        
        return try Data(contentsOf: fileURL)
    }
    
    private func parseData(_ data: Data) throws -> [Rebus] {
        try decoder.decode([Rebus].self, from: data)
    }
}
