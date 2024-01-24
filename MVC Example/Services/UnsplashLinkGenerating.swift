import Foundation

protocol UnsplashLinkGenerating {
    func makeLinks(from identifiers: [String]) -> [String]
}

extension UnsplashLinkGenerating {
    func makeLinks(from identifiers: [String]) -> [String] {
        return identifiers.map { id in
            return "https://unsplash.com/photos/\(id)/download?force=true&w=150"
        }
    }
}
