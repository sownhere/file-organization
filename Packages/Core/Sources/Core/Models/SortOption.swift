import Foundation

public enum SortOption: String, Sendable, Equatable, Hashable, CaseIterable {
    case name
    case date
    case size
    case type

    public var displayName: String {
        switch self {
        case .name: "Name"
        case .date: "Date"
        case .size: "Size"
        case .type: "Type"
        }
    }
}
