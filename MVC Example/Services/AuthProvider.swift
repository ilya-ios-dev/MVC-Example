import Foundation

typealias UserID = String
protocol AuthProvider {
    func verifyAuthentication() async throws -> UserID
}

class AuthService: AuthProvider {
    func verifyAuthentication() async throws -> UserID {
        try await Task.sleep(for: .seconds(2))
        return UUID().uuidString
    }
}
