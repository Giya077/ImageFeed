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
    case urlSessionError
}

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let tokenStorage = OAuth2TokenStorage.shared
    private let baseURL = "https://api.unsplash.com/users/"
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    
    private init() {}
    
    struct UserResult: Codable {
        let profileImage: ProfileImageURL
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    struct ProfileImageURL: Codable {
        let large: String
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = tokenStorage.token else {
            let missingToken = ProfileImageServiceError.missingToken
            print("[fetchProfileImageURL]: Profile Image Service Error - \(missingToken)")
            completion(.failure(missingToken))
            return
        }
        
        if let task = self.task {
            // Если запрос уже выполняется, не создаем новый
            task.cancel()
        }
        
        guard let request = makeURLRequest(for: username, with: token) else {
            let invalidURL = ProfileImageServiceError.invalidURL
            print("[fetchProfileImageURL]: Profile Image Service Error - \(invalidURL)")
            completion(.failure(invalidURL))
            return
        }
        
        let session = URLSession.shared
        task = session.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case.success(let userResult):
                self.avatarURL = userResult.profileImage.large
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": userResult.profileImage.large]
                    )
                completion(.success(userResult.profileImage.large))
            case .failure(let error):
                let invalidSessionError = ProfileImageServiceError.urlSessionError
                print("[objectTask]: fetchProfileImageURL - \(invalidSessionError)")
                
                completion(.failure(error))
            }
        }
        task?.resume()
    }
    
    private func makeURLRequest(for username: String, with token: String) -> URLRequest? {
        let urlString = baseURL + username
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func resetAvatar() {
        avatarURL = nil
    }
}
