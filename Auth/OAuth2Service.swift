//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by GiyaDev on 07.03.2024.
//

import Foundation


final class OAuth2Service {
    static let shared = OAuth2Service() //точка входа
    private init() {} // единственный экземпляр класса
    
    private let baseUrl = URL(string: "https://unsplash.com/oauth/token")
    private let clientID = "client_id"
    private let clientSecret = "client_secret"
    private let redirectURI = "redirect_uri"
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? { //Создает и возвращает URLRequest для запроса на получение авторизационного токена
        guard let baseURL = URL(string: "https://unsplash.com/oauth/token"),
              var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
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
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            let error = NSError(domain: "OAuth2Service", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create URL request"])
            print("Error creating URL request: \(error.localizedDescription)")
            completion(.failure(NetworkError.urlRequestError(error)))
            return
        }

        // Используем расширение URLSession для выполнения запроса и обработки данных
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("URL session error: \(error.localizedDescription)")
                completion(.failure(NetworkError.urlSessionError))
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                print("Failed to receive valid data or response")
                completion(.failure(NetworkError.urlSessionError))
                return
            }

            if 200 ..< 300 ~= response.statusCode {
                do {
                    let decodedResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    let accessToken = decodedResponse.accessToken
                    OAuth2TokenStorage.shared.token = accessToken
                    completion(.success(accessToken))
                } catch {
                    print("Error decoding JSON response: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } else {
                print("HTTP status code error: \(response.statusCode)")
                completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
            }
        }
        task.resume()
    }
}
