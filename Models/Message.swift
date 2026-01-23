import Foundation

struct Message: Identifiable, Equatable {
    enum Status: Equatable {
        case sent
        case delivered
        case read
    }
    
    let id: String
    let text: String
    let isOutgoing: Bool
    let timestamp: Date
    var status: Status = .sent
}
