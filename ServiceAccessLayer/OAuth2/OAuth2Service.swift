//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by GiyaDev on 07.03.2024.
//

import Foundation

enum AuthServiceError: Error {
    case duplicateRequest
}

final class OAuth2Service {
    
    static let shared = OAuth2Service() //точка входа
    private init() {} // единственный экземпляр класса

    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            let error = NSError(domain: "OAuth2Service", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create URL request"])
            print("Error creating URL request: \(error.localizedDescription)")
            completion(.failure(NetworkError.urlRequestError(error)))
            return
        }
        
        assert(Thread.isMainThread) // Убедимся, что мы на главном потоке
        
        if let task = self.task {
            if lastCode != code {
                task.cancel()
            } else {
                // Если текущий код совпадает с предыдущим, возвращаем ошибку
                completion(.failure(AuthServiceError.duplicateRequest))
                print("Error fetching OAuth token")
                return
            }
        }
        
        lastCode = code // Запоминаем текущий код

        let task = URLSession.shared.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
                  switch result {
                  case .success(let decodedResponse):
                      DispatchQueue.main.async {
                          completion(.success(decodedResponse))
                      }
                  case .failure(let error):
                      completion(.failure(error))
                  }
                  
                  // Обнуляем задачу и код
                  self.task = nil
                  self.lastCode = nil
              }
              // Запускаем задачу
              task.resume()
              
              // Сохраняем ссылку на задачу
              self.task = task
          }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? { //Создает и возвращает URLRequest для запроса на получение авторизационного токена
        guard let baseURL = URL(string: "https://unsplash.com/oauth/token"),
              var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            assertionFailure("Failed to create URL components")
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
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}

