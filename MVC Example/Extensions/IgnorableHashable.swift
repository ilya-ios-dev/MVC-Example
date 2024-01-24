import Foundation

@propertyWrapper
struct IgnorableHashable<Wrapped>: Hashable {
    @IgnorableEquatable var wrappedValue: Wrapped
    func hash(into hasher: inout Hasher) {}
}

@propertyWrapper
struct IgnorableEquatable<Wrapped>: Equatable {
    var wrappedValue: Wrapped
    static func == (lhs: IgnorableEquatable<Wrapped>, rhs: IgnorableEquatable<Wrapped>) -> Bool {
        true
    }
}
