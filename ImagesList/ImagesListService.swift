import Foundation

enum ImagesListServiceError: Error {
    case urlError
    case failedToFetchPhotos
}

struct User {
    let id: String
    let username: String
    let name: String
    let profileImageURL: String
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLicked: Bool
    let user: User // Используем упрощенную информацию о пользователе
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: Date
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
    let user: UserResult // Обновляем для парсинга информации о пользователе
}

struct UserResult: Codable {
    let id: String
    let username: String
    let name: String
    let profile_image: ProfileImage
}

struct ProfileImage: Codable {
    let medium: String
}

struct UrlsResult: Codable {
    let thumb: String
    let regular: String
}

final class ImagesListService {
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var isFetching: Bool = false
    
    private init() {}
    
    func fetchPhotosNextPage() {
        guard !isFetching else { return } // Проверяем, не выполняется ли уже загрузка
        
        isFetching = true // Устанавливаем флаг, что начали загрузку
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let url = URL(string: "https://api.unsplash.com/photos") else {
            let urlError = ImagesListServiceError.urlError
            print("[fetchPhotosNextPage]: ImagesListServiceError - \(urlError)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.objectTask(for: request) { (result: Result <[PhotoResult], Error>) in
            switch result {
            case .success(let photoResults):
                let photos  = photoResults.map { photoResult in
                    let user = User(
                        id: photoResult.user.id,
                        username: photoResult.user.username,
                        name: photoResult.user.name,
                        profileImageURL: photoResult.user.profile_image.medium
                    )
                    return Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: photoResult.createdAt,
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        largeImageURL: photoResult.urls.regular,
                        isLicked: photoResult.likedByUser,
                        user: user
                    )
                }
                self.photos.append(contentsOf: photos)
                self.lastLoadedPage = nextPage
            case .failure(_):
                let failedToFetchPhotos = ImagesListServiceError.failedToFetchPhotos
                print("[fetchPhotosNextPage]: ImagesListServiceError - \(failedToFetchPhotos)")
            }
            self.isFetching = false
        }
        task.resume()
    }
}
