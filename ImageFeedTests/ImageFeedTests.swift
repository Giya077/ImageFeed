//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by GiyaDev on 01.02.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    
    func testFetchPhotos() {
        let service = ImagesListService.shared
        
        let expectation = self.expectation(description: "Wait for Photos")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)
        
        let numberOfPhotos = service.numberOfLoadedPhotos()
        print("Number of photos loaded: \(numberOfPhotos)")
        
        // Проверяем, что после загрузки фотографий их количество равно 10
        XCTAssertEqual(numberOfPhotos, 10)
    }
}
