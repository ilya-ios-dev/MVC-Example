import Foundation

protocol UnsplashImagesProvider {
    func images() async throws -> [UnsplashImageResponse]
}

class UnsplashImagesService: UnsplashImagesProvider {
    func images() async throws -> [UnsplashImageResponse] {
        try await Task.sleep(for: .seconds(3))
        let imageIDs = ["DnkjT7elQZU", "HI6ArHbjvaE", "2Q9-4by19qY", "F-wJf4vQEWE", "ABzeDltwm9k", "swx_rlAr7LI", "nviNZi55Nrk", "w8zJdG8R_LE", "AOHftEzsLoQ", "jzFbbG2WXv0", "s9NttXGehL4", "jlphfn0fk4A", "M6KJaQ54oB0", "KnVHUtV3-Mw", "VoGnr2c8j-Y", "7rXqMiPA48E"]
            
        return imageIDs.map { id in
            return UnsplashImageResponse(url: "https://unsplash.com/photos/\(id)/download?force=true&w=150", id: id)
        }
    }
}
