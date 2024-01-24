import Foundation

protocol BuildingImagesProvider {
    func images() async throws -> [BuildingResponse]
    func deleteImage(_ id: Int) async -> [BuildingResponse]
}

class BuildingImagesService: BuildingImagesProvider, UnsplashLinkGenerating {
    private enum LoadingError: Error {
        case randomError
    }
    
    private var imageIdentifiers = [
        "Fa-o2AJscng",
        "QfKczKL1jgY",
        "PsXJVxEhVxI",
        "0zWSGlVWqBo",
        "MPw0EWSUh44",
        "w8zJdG8R_LE",
        "VnjSkqXTN9w"
    ]

    func images() async throws -> [BuildingResponse] {
        try await Task.sleep(for: .seconds(4))
        
        let isRequestSucceed = Bool.random()
        guard isRequestSucceed else {
            throw LoadingError.randomError
        }
                   
        let urls = makeLinks(from: imageIdentifiers)
        return urls.enumerated().map { index, url in
            return BuildingResponse(url: url, id: index)
        }
    }
    
    func deleteImage(_ id: Int) async -> [BuildingResponse] {
        imageIdentifiers.remove(at: id)
        
        let urls = makeLinks(from: imageIdentifiers)
        return urls.enumerated().map { index, url in
            return BuildingResponse(url: url, id: index)
        }
    }
}
