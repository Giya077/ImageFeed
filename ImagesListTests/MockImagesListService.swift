//
//  MockImagesListService.swift
//  ImagesListTests
//
//  Created by GiyaDev on 26.04.2024.
//
@testable import ImageFeed
import Foundation
import XCTest


class MockImagesListService: ImagesListServiceProtocol {
    
    var photos: [ImageFeed.Photo] = []
    var didFetchPhotosNextPage = false
    var didChangeLikeCalled = false
    
    init() {
            // Загрузка тестовых данных
            photos = [
                Photo(id: "1", 
                      size: CGSize(width: 100, height: 100),
                      createdAt: Date(),
                      welcomeDescription: "Test",
                      thumbImageURL: "thumbURL",
                      regularImageURL: "regularURL",
                      fullImageURL: "fullURL",
                      isLiked: false,
                      user: User(
                        id: "1",
                        username: "testuser",
                        name: "Test User",
                        profileImageURL: "profileURL"))
                ]
                }
                
    func fetchPhotosNextPage() {
        didFetchPhotosNextPage = true
    }
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        didChangeLikeCalled = true
        completion(.success(()))
        print("MockImagesListService - changeLike called")
    }
}


