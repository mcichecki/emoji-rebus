import Foundation

enum ParserError: Error {
    case noFile
}

final class Parser {
    static let shared = Parser()
    var numberOfRebuses: Int { rebuses.count }
    private(set) var rebuses: [Rebus] = []
        
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
        } catch { }
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

public final class RebusEncoder {
    public static let shared = RebusEncoder()
    private lazy var encoder = JSONEncoder()
    
    public func encode(rebuses: [Rebus]) -> String {
        guard let data = try? encoder.encode(rebuses),
            let text = String(data: data, encoding: .utf8) else { return "" }
        
        return text
    }
    
    // TODO: Remove?
    public func printStats(rebuses: [Rebus]) {
        let count = rebuses.count
        let sortedByNumberOfComponents = rebuses.sorted { r1, r2 in r1.components.count < r2.components.count }
        let numberOfComponents = sortedByNumberOfComponents.map { $0.components.count }
        let averageComponentsNumber = Double(numberOfComponents.reduce(0, +)) / Double(numberOfComponents.count)
        
        print("number of rebuses: \(count)")
        print("components: \(numberOfComponents)")
        print("average components number: \(averageComponentsNumber)")
    }
}
