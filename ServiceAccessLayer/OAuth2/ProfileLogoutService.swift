//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by GiyaDev on 08.04.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        resetProfileData()
        clearToken()
        navigateToInitialScreen()
        
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func resetProfileData() {
        ProfileService.shared.resetProfile()
        ProfileImageService.shared.resetAvatar()
        ImagesListService.shared.resetImagesList()
    }
    
    private func navigateToInitialScreen() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        // Создаем экземпляр начального контроллера
        let initialViewController =  SplashViewController()
        
        // Устанавливаем созданный контроллер как корневой
        window.rootViewController = initialViewController
        
        // Применяем изменения
        window.makeKeyAndVisible()
    }
    
    private func clearToken() {
        OAuth2TokenStorage.shared.token = nil
    }
}
