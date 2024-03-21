//
//  ProfileService.swift
//  ImageFeed
//
//  Created by GiyaDev on 18.03.2024.
//

import Foundation

enum ProfileServiceError: Error {
    case invalidURL
    case noData
    case invalidData
}

final class ProfileService {
    
    private(set) var profile: Profile?
    static let shared = ProfileService()
    
    private init() {}
    
    private var task: URLSessionTask?
    
    struct ProfileResult: Codable {
        let id: String
        let updatedAt: Date
        let username: String
        let firstName: String?
        let lastName: String?
        let twitterUsername: String?
        let portfolioURL: URL?
        let bio: String?
        let location: String?
        let totalLikes: Int
        let totalPhotos: Int
        let totalCollections: Int
        let followedByUser: Bool
        let downloads: Int
    }
    
    struct Profile {
        let userName: String
        let name: String
        let loginName: String
        let bio: String?
        
        init(userName: String, firstName: String, lastName: String, bio: String?) {
            self.userName = userName
            self.name = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
            self.loginName = "@\(userName)"
            self.bio = bio
        }
    }
    
    private func makeUrlRequest(endpoint: String, bearerToken: String) -> URLRequest? {
        guard let url = URL(string: endpoint) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
        
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let request = makeUrlRequest(endpoint: "https://api.unsplash.com/me", bearerToken: token) else {
            completion(.failure(ProfileServiceError.invalidURL))
            return
        }
        
        if let task = self.task {
            task .cancel()
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case.success(let profileResult):
                let profile = Profile(
                    userName: profileResult.username,
                    firstName: profileResult.firstName ?? "",
                    lastName: profileResult.lastName ?? "",
                    bio: profileResult.bio)
                self.profile = profile
                completion(.success(profile))
            case.failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
        self.task = task
    }
}
