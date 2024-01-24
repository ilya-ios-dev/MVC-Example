import Foundation

protocol ImagesOfTheDayProvider {
    func images(for userID: UserID) async throws -> [ImagesOfTheDayResponse]
    func deleteImage(_ id: String) async throws -> [ImagesOfTheDayResponse]
}

class ImagesOfTheDaySerivce: ImagesOfTheDayProvider, UnsplashLinkGenerating {
    private var imageIdentifiers = [
        "tNdVSO6eqZY",
        "cPd16K15WfI",
        "GvaItXBklN0",
        "Y2GHRzYqo2o",
        "lTiS6VVjFyg",
        "-BNm8s2uDnk",
        "-coHuTi1AOA"
    ]

    func images(for userID: UserID) async throws -> [ImagesOfTheDayResponse] {
        try await Task.sleep(for: .seconds(2))
        let urls = makeLinks(from: imageIdentifiers)
        return zip(urls, imageIdentifiers).map(ImagesOfTheDayResponse.init)
    }
    
    func deleteImage(_ id: String) async throws -> [ImagesOfTheDayResponse] {
        imageIdentifiers.removeAll { $0 == id }
        let urls = makeLinks(from: imageIdentifiers)
        return zip(urls, imageIdentifiers).map(ImagesOfTheDayResponse.init)
    }
}
