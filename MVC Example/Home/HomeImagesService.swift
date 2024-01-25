import Foundation

struct ImageResponses {
    let imagesOfTheDay: [ImagesOfTheDayResponse]?
    let unsplashImages: [UnsplashImageResponse]?
    let buildingImages: [BuildingResponse]?
}

protocol HomeImagesProvider {
    func fetchImages() async -> ImageResponses
    func deleteImage(with identifier: ImageItemIdentifier, currentResult: ImageResponses) async -> ImageResponses
    func reloadImages(for identifier: HomeSectionIdentifier, currentResult: ImageResponses) async -> ImageResponses
}

class HomeImagesService: HomeImagesProvider {
    
    private let authProvider: AuthProvider = AuthService()
    private let imagesOfTheDayProvider: ImagesOfTheDayProvider = ImagesOfTheDaySerivce()
    private let imagesProvider: UnsplashImagesProvider = UnsplashImagesService()
    private let buildingImagesProvider: BuildingImagesProvider = BuildingImagesService()

    func fetchImages() async -> ImageResponses {
        return await ImageResponses(
            imagesOfTheDay: imagesOfTheDay(),
            unsplashImages: unsplashImages(),
            buildingImages: buildingImages()
        )
    }
    
    private func imagesOfTheDay() async -> [ImagesOfTheDayResponse]? {
        guard let userID = try? await self.authProvider.verifyAuthentication() else {
            return nil
        }
        
        return try? await self.imagesOfTheDayProvider.images(for: userID)
    }
    
    private func unsplashImages() async -> [UnsplashImageResponse]? {
        return try? await imagesProvider.images()
    }
    
    private func buildingImages() async -> [BuildingResponse]? {
        return try? await buildingImagesProvider.images()
    }
    
    func deleteImage(with identifier: ImageItemIdentifier, currentResult: ImageResponses) async -> ImageResponses {
        switch identifier {
        case .imageOfTheDay(let id):
            return await currentResult.updating(
                imagesOfTheDay: try? imagesOfTheDayProvider.deleteImage(id)
            )
        case .unsplashImage(let id):
            return await currentResult.updating(
                unsplashImages: try? imagesProvider.deleteImage(id)
            )
        case .buildingImage(let id):
            return await currentResult.updating(
                buildingImages: try? buildingImagesProvider.deleteImage(id)
            )
        }
    }

    func reloadImages(for identifier: HomeSectionIdentifier, currentResult: ImageResponses) async -> ImageResponses {
        switch identifier {
        case .imageOfTheDay:
            return await currentResult.updating(
                imagesOfTheDay: imagesOfTheDay()
            )
        case .unsplashImage:
            return await currentResult.updating(
                unsplashImages: unsplashImages()
            )
        case .buildingImage:
            return await currentResult.updating(
                buildingImages: buildingImages()
            )
        }
    }
}

private extension ImageResponses {
    func updating(imagesOfTheDay: [ImagesOfTheDayResponse]?) -> Self {
        return .init(imagesOfTheDay: imagesOfTheDay, unsplashImages: unsplashImages, buildingImages: buildingImages)
    }
    
    func updating(unsplashImages: [UnsplashImageResponse]?) -> Self {
        return .init(imagesOfTheDay: imagesOfTheDay, unsplashImages: unsplashImages, buildingImages: buildingImages)
    }

    func updating(buildingImages: [BuildingResponse]?) -> Self {
        return .init(imagesOfTheDay: imagesOfTheDay, unsplashImages: unsplashImages, buildingImages: buildingImages)
    }
}
