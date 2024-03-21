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
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ProfileServiceError.noData))
                return
            }
            
            do {
                let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                let profile = Profile(userName: profileResult.username,
                                      firstName: "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")",
                                      lastName: "@\(profileResult.username)",
                                      bio: profileResult.bio)
                self.profile = profile
                completion(.success(profile))
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(.failure(ProfileServiceError.invalidData))
            }
        }
        task.resume()
        self.task = task
    }
}
