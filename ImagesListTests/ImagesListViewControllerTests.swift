//
//  ImagesListViewControllerTests.swift
//  ImagesListTests
//
//  Created by GiyaDev on 28.04.2024.
//

@testable import ImageFeed
import XCTest

class ImagesListViewControllerTests: XCTestCase {
    var imagesListViewController: ImagesListViewController!
    var spyView: ImagesListViewControllerSpy!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        imagesListViewController.loadView()
        spyView = ImagesListViewControllerSpy()
        imagesListViewController.setView(spyView)
    }

    override func tearDown() {
        imagesListViewController = nil
        spyView = nil
        super.tearDown()
    }
    
    func testTableViewNotNil() {
        XCTAssertNotNil(imagesListViewController.tableView, "tableView should not be nil after setupTableView()")
    }

    func testPerformSegueCalled() {
        let photo = Photo(id: "1", size: CGSize(width: 100, height: 100), createdAt: Date(), welcomeDescription: "Test", thumbImageURL: "thumbURL", regularImageURL: "regularURL", fullImageURL: "fullURL", isLiked: false, user: User(id: "1", username: "testuser", name: "Test User", profileImageURL: "profileURL"))
        spyView.performSegueToSingleImage(with: photo)

        XCTAssertTrue(spyView.performSegueCalled, "performSegueToSingleImage should be called when performing segue")
    }
}
