import Foundation

/// Marker protocol for State objects.
/// State should be:
/// - Immutable (struct)
/// - Equatable
protocol State: Equatable {}

/// Marker protocol for Events.
/// Events flow from UI -> Controller.
protocol Event {}
