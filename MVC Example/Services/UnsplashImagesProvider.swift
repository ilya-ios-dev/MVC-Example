import Foundation

protocol UnsplashImagesProvider {
    func images() async throws -> [UnsplashImageResponse]
    func deleteImage(_ id: String) async throws -> [UnsplashImageResponse]
}

class UnsplashImagesService: UnsplashImagesProvider, UnsplashLinkGenerating {
    private var imageIdentifiers = [
        "DnkjT7elQZU",
        "HI6ArHbjvaE",
        "2Q9-4by19qY", 
        "F-wJf4vQEWE",
        "ABzeDltwm9k",
        "swx_rlAr7LI",
        "nviNZi55Nrk",
        "AOHftEzsLoQ",
        "jzFbbG2WXv0",
        "s9NttXGehL4",
        "jlphfn0fk4A",
        "M6KJaQ54oB0",
        "KnVHUtV3-Mw",
        "VoGnr2c8j-Y",
        "7rXqMiPA48E"
    ]
    
    func images() async throws -> [UnsplashImageResponse] {
        try await Task.sleep(for: .seconds(3))
        let urls = makeLinks(from: imageIdentifiers)
        return zip(urls, imageIdentifiers).map(UnsplashImageResponse.init)
    }
    
    func deleteImage(_ id: String) async throws -> [UnsplashImageResponse] {
        imageIdentifiers.removeAll { $0 == id }
        let urls = makeLinks(from: imageIdentifiers)
        return zip(urls, imageIdentifiers).map(UnsplashImageResponse.init)
    }
}
