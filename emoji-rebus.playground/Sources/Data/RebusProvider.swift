import Foundation

struct StoredRebus {
    let rebus: Rebus
    let completed: Bool
}

final class RebusProvider {
    static let shared = RebusProvider()
    
    private(set) var rebuses: [StoredRebus] = []
    
    init() {
        rebuses = Array(Parser.shared.rebuses.map { StoredRebus(rebus: $0, completed: false) }[0...2])
    }
    
    func getRebus(at index: Int) -> Rebus? {
        guard rebuses.indices.contains(index) else { return nil }
        
        return rebuses[index].rebus
    }
    
    func markAsComplete(index: Int) {
        guard rebuses.indices.contains(index) else { return }

        rebuses[index] = StoredRebus(rebus: rebuses[index].rebus, completed: true)
    }
}
