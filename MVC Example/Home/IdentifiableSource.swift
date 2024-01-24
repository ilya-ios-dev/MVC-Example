import Foundation

protocol IdentifiableSource {}

enum ImageItemIdentifier: IdentifiableSource {
    case imageOfTheDay(String)
    case unsplashImage(String)
    case buildingImage(Int)
}

enum HomeSectionIdentifier: IdentifiableSource {
    case imageOfTheDay
    case unsplashImage
    case buildingImage
}
