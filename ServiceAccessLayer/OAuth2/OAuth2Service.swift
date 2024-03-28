//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by GiyaDev on 07.03.2024.
//

import Foundation

enum OAuthRequestError: Error {
    case urlComponentError
    case urlCreationError
    case duplicateRequest
    case urlRequestError(Error)
    case decodingError(Error)
}

final class OAuth2Service {
    
    static let shared = OAuth2Service() //точка входа
    private init() {}
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        print("Requesting OAuth token with authorization code: \(code)")
        
        // Создаем запрос на получение токена
        guard let request = makeOAuthTokenRequest(code: code) else {
            let urlRequestError = OAuthRequestError.urlRequestError(NSError(domain: "OAuth2Service", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create URL request"]))
            print("[fetchOAuthToken]: OAuthRequestError \(urlRequestError)")
            completion(.failure(urlRequestError))
            return
        }
        
        // Выполняем запрос с помощью objectTask
        URLSession.shared.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let decodedResponse):
                let accessToken = decodedResponse.accessToken
                OAuth2TokenStorage.shared.token = accessToken
                DispatchQueue.main.async {
                    completion(.success(accessToken))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                    let decodingError = OAuthRequestError.decodingError(error)
                    print("[OAuth2Service.fetchOAuthToken]: \(decodingError)")
                }
            }
        }.resume()
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? { //Создает и возвращает URLRequest для запроса на получение авторизационного токена
        guard let baseURL = URL(string: "https://unsplash.com/oauth/token"),
              var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            let urlComponentsError = OAuthRequestError.urlComponentError
            print("[makeOAuthTokenRequest]: OAuthRequestError - \(urlComponentsError)")
            return nil
        }
        
        let queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        components.queryItems = queryItems
        
        guard let url = components.url else {
            let urlError = OAuthRequestError.urlCreationError
            print("[makeOAuthTokenRequest]: OAuthRequestError \(urlError)")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}

