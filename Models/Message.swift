import Foundation

struct Message: Identifiable, Equatable {
    let id: UUID
    let text: String
    let isOutgoing: Bool
    let timestamp: Date
}
