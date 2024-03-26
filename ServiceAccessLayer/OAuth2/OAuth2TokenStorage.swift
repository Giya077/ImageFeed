//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by GiyaDev on 09.03.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "OAuth2AccessToken"
    
    
    
    
    var token: String? {
        get {
            // Извлечение токена из Keychain
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            // Сохранение токена в Keychain
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            } else {
                // Если токен равен nil, удаляем его из Keychain
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
