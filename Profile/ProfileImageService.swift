//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by GiyaDev on 20.03.2024.
//

import Foundation

enum ProfileImageServiceError: Error {
    case missingToken
    case invalidURL
    case noData
    case invalidData
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let tokenStorage = OAuth2TokenStorage.shared
    private let baseURL = "https://api.unsplash.com/users/"
    var avatarURL: String?
    private var task: URLSessionDataTask?
    
    private init() {}
    
    struct UserResult: Codable {
        let profileImage: ProfileImageURL
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    struct ProfileImageURL: Codable {
        let small: String
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = tokenStorage.token else {
            completion(.failure(ProfileImageServiceError.missingToken))
            return
        }
        
        if let task = self.task {
            // Если запрос уже выполняется, не создаем новый
            task.cancel()
        }
        
        guard let request = makeURLRequest(for: username, with: token) else {
            completion(.failure(ProfileImageServiceError.invalidURL))
            return
        }
        
        let session = URLSession.shared
        task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ProfileImageServiceError.noData))
                return
            }
            
            do {
                let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                self.avatarURL = userResult.profileImage.small
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": userResult.profileImage.small]
                )
                completion(.success(userResult.profileImage.small))
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(.failure(ProfileImageServiceError.invalidData))
            }
        }
        
        task?.resume()
//        self.task = task
    }
    
    private func makeURLRequest(for username: String, with token: String) -> URLRequest? {
        let urlString = baseURL + username
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
