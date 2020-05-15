import Foundation

struct StoredRebus {
    let rebus: Rebus
    let completed: Bool
}

final class RebusProvider {
    static let shared = RebusProvider()
    
    private(set) var rebuses: [StoredRebus] = []
    
    var numberOfCompleted: Int { rebuses.filter { $0.completed }.count }
    
    init() {
        rebuses = Parser.shared.rebuses
            .shuffled()
            .sorted { $0.difficultyLevel.rawValue < $1.difficultyLevel.rawValue }
            .map { StoredRebus(rebus: $0, completed: false) }
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
